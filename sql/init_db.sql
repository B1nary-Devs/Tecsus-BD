-- Privilegios para acesso no banco de dados
CREATE USER 'b1nary'@'%' IDENTIFIED BY 'tecsus';
GRANT ALL PRIVILEGES ON tecsusDB.* TO 'b1nary'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- Modo estrela da conta e contrato agua

-- dimensão tempo
CREATE TABLE IF NOT EXISTS dim_tempo (
    data_id int AUTO_INCREMENT primary key,
    data_full date,
    dia int,
    mes int,
    ano int,
    trimestre int,
    semestre int,
    dia_da_semana varchar(10),
    mes_nome varchar(15)
);

-- dimensão contrato
CREATE TABLE IF NOT EXISTS dim_agua_contrato (
    numero_contrato int AUTO_INCREMENT primary key, 
    nome_do_contrato varchar(255), 
    fornecedor varchar(255), 
    forma_de_pagamento varchar(50), 
    tipo_de_acesso varchar(50), 
    data_id_vigencia_inicial int, 
    data_id_vigencia_final int, 
    ativado varchar(30),
    foreign key (data_id_vigencia_inicial) references dim_tempo(data_id),
	foreign key (data_id_vigencia_final) references dim_tempo(data_id)
);

-- dimensão cliente
CREATE TABLE IF NOT EXISTS dim_agua_cliente (
    numero_cliente int AUTO_INCREMENT primary key, 
    numero_contrato int, 
    nome_cliente varchar(255),  
    cnpj varchar(14), 
    tipo_de_consumidor varchar(50),  
    modelo_de_faturamento varchar(255),
    foreign key (numero_contrato) references dim_agua_contrato(numero_contrato)
);


-- dimensão medidor
CREATE TABLE IF NOT EXISTS dim_agua_medidor (
    numero_medidor int AUTO_INCREMENT primary key, 
    hidrometro varchar(255),
    codigo_de_ligacao_rgi varchar(50),
    numero_contrato int,
	endereco_de_instalacao varchar(255),
    numero_cliente int,
    foreign key (numero_cliente) references dim_agua_cliente(numero_cliente),
    foreign key (numero_contrato) references dim_agua_contrato(numero_contrato)
);


-- fato consumo
CREATE TABLE IF NOT EXISTS fato_agua_consumo (
	fato_agua_id int AUTO_INCREMENT primary key,
	consumo_de_agua_m3 decimal(9,3),
	consumo_de_esgoto_m3 decimal(9,3),
	valor_agua float,
	valor_esgoto float,
	total_r float,
	nivel_de_informacoes_da_fatura varchar(21),
	numero_cliente int,
	numero_medidor int,
	numero_contrato int,
    data_id_conta_do_mes int,
	data_id_vencimento int,
	data_id_emissao int,
	data_id_leitura_anterior int,
	data_id_leitura_atual int,
    foreign key (data_id_conta_do_mes) references dim_tempo(data_id),
	foreign key (data_id_vencimento) references dim_tempo(data_id),
	foreign key (data_id_emissao) references dim_tempo(data_id),
	foreign key (data_id_leitura_anterior) references dim_tempo(data_id),
	foreign key (data_id_leitura_atual) references dim_tempo(data_id),
	foreign key (numero_cliente) references dim_agua_cliente(numero_cliente),
	foreign key (numero_medidor) references dim_agua_medidor(numero_medidor),
	foreign key (numero_contrato) references dim_agua_contrato(numero_contrato)
);


-- Modo estrela da conta e contrato energia
 
-- criação da tabela de dimensão tempo
CREATE TABLE IF NOT EXISTS dim_energia_tempo (
    data_id INT AUTO_INCREMENT PRIMARY KEY,
    data_full DATE,
    dia INT,
    mes INT,
    ano INT,
    trimestre INT,
    semestre INT,
    dia_da_semana VARCHAR(10),
    mes_nome VARCHAR(15)
);
 
-- criação da tabela de dimensão contratos
CREATE TABLE IF NOT EXISTS dim_energia_contrato (
    numero_contrato INT PRIMARY KEY,
    nome_do_contrato VARCHAR(255),
    fornecedor VARCHAR(255),
    classe VARCHAR(255),
    horario_de_ponta VARCHAR(20),
    demanda_ponta varchar(10),
    demanda_fora_ponta varchar(10),
    tensao_contratada varchar(20),
    data_id_vigencia_inicial_id INT,
    data_id_vigencia_final_id INT,
    ativado varchar(30),
    FOREIGN KEY (data_id_vigencia_inicial_id) REFERENCES dim_energia_tempo(data_id),
    FOREIGN KEY (data_id_vigencia_final_id) REFERENCES dim_energia_tempo(data_id)
);
 
-- dimensão cliente
CREATE TABLE IF NOT EXISTS dim_energia_cliente (
    numero_cliente INT AUTO_INCREMENT PRIMARY KEY,
    numero_contrato INT,
    cnpj VARCHAR(20),
    tipo_de_consumidor VARCHAR(50),
    FOREIGN KEY (numero_contrato) REFERENCES dim_energia_contrato(numero_contrato)
);
 
-- dimensão medidor
CREATE TABLE IF NOT EXISTS dim_energia_medidor (
    numero_medidor INT AUTO_INCREMENT PRIMARY KEY,
    numero_da_instalacao varchar(30),
    numero_contrato INT,
    endereco_de_instalacao VARCHAR(255),
    numero_cliente INT,
    FOREIGN KEY (numero_cliente) REFERENCES dim_energia_cliente(numero_cliente),
    FOREIGN KEY (numero_contrato) REFERENCES dim_energia_contrato(numero_contrato)
);
 
-- criação da tabela fato fatura de vencimento da conta
CREATE TABLE IF NOT EXISTS fato_energia_consumo (
    fato_energia_id INT AUTO_INCREMENT PRIMARY KEY,
    consumo_em_ponta varchar(20),
    consumo_fora_de_ponta_capacidade DECIMAL(11, 3),
    consumo_fora_de_ponta_industrial DECIMAL(11, 3),
    demanda_de_ponta_kw DECIMAL(11, 3),
    demanda_fora_de_ponta_capacidade DECIMAL(11, 3),
    demanda_fora_de_ponta_industrial DECIMAL(11, 3),
    demanda_faturada_custo DECIMAL(11, 2),
    demanda_faturada_pt_custo DECIMAL(11, 2),
    demanda_faturada_fp_custo DECIMAL(11, 2),
    demanda_ultrapassada_kw DECIMAL(11, 3),
    demanda_ultrapassada_custo DECIMAL(11, 2),
    total_da_fatura DECIMAL(11, 2),
    nivel_de_informacoes_da_fatura varchar(30),
    data_id_leitura_anterior INT,
    data_id_leitura_atual INT,
    data_id_emissao INT,
    data_id_conta_do_mes int,
    data_id_vencimento int,
    numero_cliente INT,
    numero_medidor INT,
    numero_contrato INT,
    FOREIGN KEY (data_id_leitura_anterior) REFERENCES dim_energia_tempo(data_id),
    FOREIGN KEY (data_id_leitura_atual) REFERENCES dim_energia_tempo(data_id),
    FOREIGN KEY (data_id_emissao) REFERENCES dim_energia_tempo(data_id),
	FOREIGN KEY (data_id_conta_do_mes) REFERENCES dim_energia_tempo(data_id),
    FOREIGN KEY (data_id_vencimento) REFERENCES dim_energia_tempo(data_id),
    FOREIGN KEY (numero_cliente) REFERENCES dim_energia_cliente(numero_cliente),
    FOREIGN KEY (numero_medidor) REFERENCES dim_energia_medidor(numero_medidor),
    FOREIGN KEY (numero_contrato) REFERENCES dim_energia_contrato(numero_contrato)
);

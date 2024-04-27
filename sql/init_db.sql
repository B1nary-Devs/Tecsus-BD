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
    vigencia_inicial_id int, 
    vigencia_final_id int, 
    ativado BOOLEAN,
    foreign key (vigencia_inicial_id) references dim_tempo(data_id),
	foreign key (vigencia_final_id) references dim_tempo(data_id)
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
	planta varchar(255),
	conta_do_mes varchar(255),
	serie_da_nota_fiscal varchar(50),
	numero_nota_fiscal varchar(255),
	codigo_de_barras varchar(255),
	chave_de_acesso varchar(255),
	consumo_de_agua_m3 int,
	consumo_de_esgoto_m3 int,
	valor_agua float,
	valor_esgoto float,
	total_r float,
	nivel_de_informacoes_da_fatura varchar(255),
	multa_ref_vcto float,
	juros_de_mora_ref_vcto float,
	atualizacao_monetaria_ref_vcto float,
	numero_cliente int,
	numero_medidor int,
	numero_contrato int,
	vencimento_id int,
	emissao_id int,
	leitura_anterior_id int,
	leitura_atual_id int,
	foreign key (vencimento_id) references dim_tempo(data_id),
	foreign key (emissao_id) references dim_tempo(data_id),
	foreign key (leitura_anterior_id) references dim_tempo(data_id),
	foreign key (leitura_atual_id) references dim_tempo(data_id),
	foreign key (numero_cliente) references dim_agua_cliente(numero_cliente),
	foreign key (numero_medidor) references dim_agua_medidor(numero_medidor),
	foreign key (numero_contrato) references dim_agua_contrato(numero_contrato)
);


-- Modo estrela da conta e contrato energia

-- criação da tabela de dimensão tempo
CREATE TABLE IF NOT EXISTS dim_energia_tempo (
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

-- criação da tabela de dimensão contratos
CREATE TABLE IF NOT EXISTS dim_energia_contrato (
	numero_contrato int AUTO_INCREMENT primary key,
    tipo_de_contrato varchar(255),
    nome_do_contrato varchar(255),
    fornecedor varchar(255),
    classe varchar(255),
    horario_de_ponta varchar(20),
    demanda_ponta decimal(10,2),
    demanda_fora_ponta decimal(10,2),
    tensao_contratada decimal(10,2),
    vigencia_inicial_id int,
    vigencia_final_id int,
    ativado boolean,
    foreign key (vigencia_inicial_id) references dim_energia_tempo(data_id),
	foreign key (vigencia_final_id) references dim_energia_tempo(data_id)
);

-- dimensão cliente
CREATE TABLE IF NOT EXISTS dim_energia_cliente (
    numero_cliente int AUTO_INCREMENT primary key, 
    numero_contrato int, 
    cnpj varchar(20),
    tipo_de_consumidor varchar(50),  
    foreign key (numero_contrato) references dim_energia_contrato(numero_contrato)
);

-- dimensão medidor ok
CREATE TABLE IF NOT EXISTS dim_energia_medidor ( 
    numero_medidor int AUTO_INCREMENT primary key,  
    numero_da_instalacao int, 
    numero_contrato int, 
	endereco_de_instalacao varchar(255), 
    numero_cliente int,
    foreign key (numero_cliente) references dim_energia_cliente(numero_cliente),
    foreign key (numero_contrato) references dim_energia_contrato(numero_contrato)
);


-- criação da tabela fato fatura de vencimento da conta
CREATE TABLE IF NOT EXISTS fato_energia_consumo (
    id_fatura int AUTO_INCREMENT primary key,
    consumo_em_ponta decimal(10, 2),
    consumo_fora_de_ponta_capacidade decimal(10, 2),
    consumo_fora_de_ponta_industrial decimal(10, 2),
	demanda_de_ponta_kw decimal(10, 2),
    demanda_fora_de_ponta_capacidade decimal(10, 2),
    demanda_fora_de_ponta_industrial decimal(10, 2),
    demanda_faturada_custo decimal(10, 2),
    demanda_faturada_pt_custo decimal(10, 2),
    demanda_faturada_fp_custo decimal(10, 2),
    demanda_ultrapassada_kw decimal(10, 2),
    demanda_ultrapassada_custo decimal(10, 2),
    total_da_fatura decimal(10, 2),
    nivel_de_informacoes_da_fatura int,
    leitura_anterior_id int,
    leitura_atual_id int,
    emissao_id int,
	numero_cliente int,
	numero_medidor int,
	numero_contrato int,
    foreign key (leitura_anterior_id) references dim_energia_tempo(data_id),
	foreign key (leitura_atual_id) references dim_energia_tempo(data_id),
	foreign key (emissao_id) references dim_energia_tempo(data_id),
	foreign key (numero_cliente) references dim_energia_cliente(numero_cliente),
	foreign key (numero_medidor) references dim_energia_medidor(numero_medidor),
	foreign key (numero_contrato) references dim_energia_contrato(numero_contrato)
);
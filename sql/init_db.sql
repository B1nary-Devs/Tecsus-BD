--Privilegios para acesso no banco de dados
update mysql.user set host='%' where user='root';
FLUSH PRIVILEGES;

-- dimensão tempo
create table dim_tempo (
    data_id int primary key,
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
create table dim_agua_contrato (
    numero_contrato varchar(100) primary key, --
    nome_do_contrato varchar(255), --
    fornecedor varchar(255), --
    forma_de_pagamento varchar(50), --
    tipo_de_acesso varchar(50), --
    vigencia_inicial_id int, --
    vigencia_final_id int, --
    ativado BOOLEAN,
    foreign key (vigencia_inicial_id) references dim_tempo(data_id),
	foreign key (vigencia_final_id) references dim_tempo(data_id)
);

-- dimensão cliente
create table dim_agua_cliente (
    numero_cliente varchar(100) primary key, --
    numero_contrato varchar(100), --
    nome_cliente varchar(255),  --
    cnpj varchar(14), --
    tipo_de_consumidor varchar(50), -- 
    modelo_de_faturamento varchar(255),
    foreign key (numero_contrato) references dim_agua_contrato(numero_contrato)
);



-- dimensão medidor
create table dim_agua_medidor (
    numero_medidor varchar(100) primary key, -- 
    hidrometro varchar(255), --
    codigo_de_ligacao_rgi varchar(50), --
    numero_contrato varchar(255), --
	endereco_de_instalacao text, --
    numero_cliente varchar(100),
    foreign key (numero_cliente) references dim_agua_cliente(numero_cliente),
    foreign key (numero_contrato) references dim_agua_contrato(numero_contrato)
);


-- fato consumo
create table fato_agua_consumo (
	fato_agua_id int auto_increment primary key,
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
	numero_cliente varchar(100),
	numero_medidor varchar(100),
	numero_contrato varchar(100),
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
	foreign key (numero_contrato) references dim_agua_contrato(numero_contrato));

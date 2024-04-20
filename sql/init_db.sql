--Privilegios para acesso no banco de dados
update mysql.user set host='%' where user='root';
FLUSH PRIVILEGES;

--SQL modo estrela
CREATE TABLE dim_agua_contrato (
    Numero_Contrato SERIAL PRIMARY KEY,
    Nome_do_Contrato VARCHAR(255),
    Fornecedor VARCHAR(255),
    Modalidade VARCHAR(255),
    Forma_de_Pagamento VARCHAR(255),
    Tipo_de_Acesso VARCHAR(255),
    Vigencia_Inicial DATE,
    Vigencia_Final DATE,
    Observacao TEXT
);
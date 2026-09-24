-- `status` fechado: grafia nova reprova em vez de virar NULL na consulta.
CREATE TYPE achado_status AS ENUM ('Aberto', 'Resolvido');

CREATE TABLE "Achado" (
    title VARCHAR,
    date DATE,
    status achado_status,
    modulo VARCHAR,
    detector VARCHAR
);

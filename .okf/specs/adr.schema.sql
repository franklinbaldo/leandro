-- Tipagem do ADR. `status` é ENUM para que grafia nova reprove em vez de
-- sumir de uma consulta como NULL.
CREATE TYPE adr_status AS ENUM ('Proposto', 'Aceito', 'Substituído', 'Revogado');

CREATE TABLE "ADR" (
    title VARCHAR,
    date DATE,
    status adr_status,
    substituido_por VARCHAR
);

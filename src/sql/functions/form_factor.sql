DROP FUNCTION IF EXISTS FormFactorLevel;
CREATE FUNCTION FormFactorLevel(
    form_factor VARCHAR(50)
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE form_factor_level INT;
    IF form_factor = 'E-ATX' THEN
        SET form_factor_level = 4;
    ELSEIF form_factor = 'ATX' THEN
        SET form_factor_level = 3;
    ELSEIF form_factor = 'mATX' THEN
        SET form_factor_level = 2;
    ELSEIF form_factor = 'Mini-ITX' THEN
        SET form_factor_level = 1;
    END IF;

        RETURN (form_factor_level);
END
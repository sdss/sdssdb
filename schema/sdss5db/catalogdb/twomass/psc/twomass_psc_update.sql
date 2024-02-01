-- After loading the data into catalogdb.twomass_psc, 
-- the designation column has an extra space at end.
-- Hence, run the below update command after loading the data.
update catalogdb.twomass_psc set designation = rtrim(designation);

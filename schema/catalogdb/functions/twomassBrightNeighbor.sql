create or replace function twomassBrightNeighbor(targRA double precision, targDec double precision, targDesig char(17), targH real)
returns bool AS $$
declare
   minH real;
   bogus real;
begin
   select count(*), min(h_m) into minH from catalogdb.twomass_psc as tm where q3c_radial_query(ra, decl, targRA, targDec, 6.0/3600.0) and tm.designation!=targDesig;
   if minH is null
   then
      return False;
   elsif (minH - targH) < 3
   then
      return True;
   else
      return False;
   end if;
end;
$$ language plpgsql;
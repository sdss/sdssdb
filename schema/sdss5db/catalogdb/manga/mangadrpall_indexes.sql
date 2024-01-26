\o mangadrpall_indexes.out

create index on catalogdb.mangadrpall(q3c_ang2ipix(objra, objdec));
create index on catalogdb.mangadrpall(q3c_ang2ipix(ifura, ifudec));
create index on catalogdb.mangadrpall(mangaid);
create index on catalogdb.mangadrpall(plate);
create index on catalogdb.mangadrpall(ifudsgn);
create index on catalogdb.mangadrpall(nsa_z);


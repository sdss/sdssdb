#.pgpass files have the format:
# host:port:database:user:password

#possible code
from os.path import expanduser

with open(expanduser('~/.pgpass'), 'r') as f:
    host, port, database, user, password = f.read().split(':')

database_uri = 'postgresql://{}:{}@{}/{}'.format(user, password, host, database)

#or use pgpasslib



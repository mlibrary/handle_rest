INSERT INTO nas SET na = '0.NA/PREFIX';

INSERT INTO handles SET
    handle = 'PREFIX/PREFIX',
    idx = 100,
    type = 'HS_ADMIN',
    data = '300:111111111111:PREFIX/PREFIX',
    ttl_type = 0,
    ttl = 86400,
    timestamp = UNIX_TIMESTAMP(CURRENT_TIMESTAMP()),
    refs='',
    admin_read = true,
    admin_write = true,
    pub_read = true,
    pub_write = false;

INSERT INTO handles SET
    handle = 'PREFIX/PREFIX',
    idx = 300,
    type = 'HS_SECKEY',
    data = 'PASSWORD',
    ttl_type = 0,
    ttl = 86400,
    timestamp = UNIX_TIMESTAMP(CURRENT_TIMESTAMP()),
    refs = '',
    admin_read = true,
    admin_write = true,
    pub_read = false,
    pub_write = false;

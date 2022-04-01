INSERT INTO nas SET na = '0.NA/PREFIX';

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

c = get_config()

# MSD-LIVE for custom gcam requirement to run basex db:
c.ServerProxy.servers = {
    'basex': {
        # 'command': ['java', '-Xms6g', '-Xmx7g', '-cp', '/basex/lib/*:/basex/BaseX.jar',
        #     '-Dorg.basex.DBPATH=/basex/data',
        #     '-Dorg.basex.ATTRINDEX=false',
        #     '-Dorg.basex.FTINDEX=false',
        #     '-Dorg.basex.UPDINDEX=false',
        #     '-Dorg.basex.CHOP=true',
        #     '-Dorg.basex.ADDCACHE=true',
        #     '-Dorg.basex.INTPARSE=true',
        #     'org.basex.BaseXHTTP', '-d'],  # command to launch the app
        'timeout': 20,  # seconds to wait for the app to start
        'absolute_url': False,  # if True, proxy will redirect to an absolute URL
        'port': 1984  # the port your app will listen on
        # 'mappath': {
        #     '/': '/rest'
        # }
    }
}
print("Loaded additional_config.py")


# java -Xms6g -Xmx7g  -cp '/basex/lib/*:/basex/BaseX.jar' \
#     -Dorg.basex.DBPATH='/basex/data' \
#     -Dorg.basex.ATTRINDEX=false \
#     -Dorg.basex.FTINDEX=false \
#     -Dorg.basex.UPDINDEX=false \
#     -Dorg.basex.CHOP=true \
#     -Dorg.basex.ADDCACHE=true \
#     -Dorg.basex.INTPARSE=true \
#     org.basex.BaseXHTTP -d 
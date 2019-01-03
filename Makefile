
.PHONY: run
run:
	TEMPORARIO_SSL_KEY_PATH=`pwd`/apps/temporario_web/priv/cert/selfsigned_key.pem \
	TEMPORARIO_SSL_CERT_PATH=`pwd`/apps/temporario_web/priv/cert/selfsigned.pem \
	TEMPORARIO_HOST=localhost \
	TEMPORARIO_PORT=4000 \
	TEMPORARIO_SECRET_BASE_KEY=jeH4eTlBnAS3YIVKagjGKfQJ8/d2Tg8Jwv3ACGJ860RS4/yqeJzGnqZWOQv0mXRL \
	TEMPORARIO_SIGNING_SALT=TcAN2yQrEMpqoJOMSUeNGc0ZFMFbcOohYpBU3L56WLXsuEw8ff94he0mgS/c24a2 \
	TEMPORARIO_ENCRYPTION_SALT=XboRvfbpoWSFe+X5qCPqzmmMhEfVMayKUeqAALyee5a6tGBbdJNhz7MlhesYAj4k \
	MIX_ENV=prod mix phx.server

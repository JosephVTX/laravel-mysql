RUN bash in container "docker exec -it laravel bash"

RUN server "php artisan octane:start --server=swoole --host=0.0.0.0"
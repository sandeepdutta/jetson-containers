docker build -t jupyter_nemo_base  --build-arg="BASE_IMAGE=dustynv/nemo:r35.4.1" -f ./packages/jupyter_nemo/Dockerfile .
docker build -t jupyter_nemo	   --build-arg="BASE_IMAGE=jupyter_nemo_base" -f ./packages/user/Dockerfile ./packages/user/

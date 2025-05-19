ls ~/.ssh/id_rsa.pub
if [ $? -ne 0 ]; then
    echo "Public key not found. Generating a new key pair..."
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -N ""
    echo "Public key generated at ~/.ssh/id_rsa.pub"
else
    echo "Public key already exists at ~/.ssh/id_rsa.pub"
fi
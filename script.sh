
    #!/bin/bash

    # sleep until instance is ready
      until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
         sleep 1
      done
    # change directory to the below

    echo "Hello, This is a test file to upload on S3" > mybucketfile.txt

    echo "<html><h1>Hello Cloud Gurus Welcome To My Webpage</h1></html>" > index.html


    echo "<html><h1>Hello Cloud Gurus Welcome To My Webpage</h1></html>" > index222.txt

    sudo cp mybucketfile.txt /var/log/

    sudo cp index.html /var/log/

    cd var/log/
 
    aws s3 mv mybucketfile.txt s3://kajidehomework001/   --recursive --exclude "*.DS_Store"
    aws s3 mv index.html s3://kajidehomework001/   --recursive --exclude "*.DS_Store"


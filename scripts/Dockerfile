FROM centos

RUN yum update -y

RUN yum install ImageMagick -y

RUN yum install wget unzip -y
RUN wget --quiet https://s3.amazonaws.com/aws-cli/awscli-bundle.zip -O /tmp/awscli-bundle.zip && unzip -qo /tmp/awscli-bundle.zip -d /tmp/ && /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/bin/aws

RUN mkdir /opt/images_to_convert
WORKDIR /opt/images_to_convert

CMD aws s3 sync s3://$AWS_S3_BUCKET/ . ; for i in `ls`; do convert "$i" "${i%.*}.png" && aws s3 cp "${i%.*}.png" s3://$AWS_S3_BUCKET/converted_files/ ; done

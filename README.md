# Build poppler for Amazon Lambda

# References
http://www.linuxfromscratch.org/blfs/view/svn/general/poppler.html
http://www.linuxfromscratch.org/blfs/view/svn/general/fontconfig.html
http://www.linuxfromscratch.org/blfs/view/svn/general/libxml2.html
http://www.linuxfromscratch.org/blfs/view/svn/general/freetype2.html

https://github.com/Automattic/node-canvas/wiki/Installation---Amazon-Linux-AMI-(EC2)

# Install
Create an EC2 instance using the Amazon Linux 64 build
Download and run build.sh script

To run the script you need to specify your S3 destination bucket as an environment variable
# Usage

```
wget https://github.com/pjfoley/poppler-for-lambda/build.sh
# Review the build.sh script
chmod +x build.sh
S3BUCKET="my-s3-bucket" ./build.sh
```

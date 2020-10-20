from diagrams import Diagram
from diagrams.onprem.iac import Ansible
from diagrams.aws.storage import S3

with Diagram("S3FS Mounts", show=False, direction="TB"):
    Ansible("ansible role s3fs mounts") - S3("s3 buckets")

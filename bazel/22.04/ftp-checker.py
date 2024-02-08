import requests
import re
import sys

# find and save the current Github release
html = str(
    requests.get('https://github.com/bazelbuild/bazel/releases/latest')
    .content)
index = html.find('Release ')
github_version = html[index + 8:index + 14]
github_version = re.sub('[^0-9\.]', '', github_version)
file = open('github_version.txt', 'w')
file.writelines(github_version)
file.close()

# find and save the current Bazel version on FTP server
html = str(
    requests.get(
        '(ftp2_ppc64le_bazel_dir)/ubuntu_' + sys.argv[1] + '/latest'
    ).content)
index = re.search(r'bazel-(\d+.\d+.\d+)', html)
ftp_version = index.group(1)
file = open('ftp_version.txt', 'w')
file.writelines(ftp_version)
file.close()

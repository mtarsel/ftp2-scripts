import requests
# find and save the current Github release
html = str(
    requests.get('https://github.com/opentofu/opentofu/releases/latest')
    .content)
index = html.find('Release ')
github_version = html[index + 9:index + 17].replace('<', '').replace(' ', '').replace('\\', '').replace('x', '').replace('/', '')
file = open('github_version.txt', 'w')
file.writelines(github_version)
file.close()

# find and save the current version on FTP server
html = str(
    requests.get(
        '(ftp2_ppc64le_opentofu_dir)/latest'
    ).content)
index = html.rfind('terraform-')
ftp_version = html[index + 10:index + 17].replace('<', '').replace(' ', '').replace('\\', '').replace('x', '').replace('/', '')
file = open('ftp_version.txt', 'w')
file.writelines(ftp_version)
file.close()

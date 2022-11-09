vagrant up

# Update synced host files for each worker and control
$ipadd_control = vagrant ssh control -c "ip address show eth0 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'" 2> $null
$ipadd_worker01 = vagrant ssh worker01 -c "ip address show eth0 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'" 2> $null
$ipadd_worker02 = vagrant ssh worker02 -c "ip address show eth0 | grep 'inet ' | sed -e 's/^.*inet //' -e 's/\/.*$//'" 2> $null

$file = "$PSScriptRoot\sync\hosts"
$host_file = Get-Content $file
if ($ipadd_control -and $ipadd_worker01 -and $ipadd_worker02)
{
    if ($host_file.count -gt 3)
    {
        $index_to_silce = $host_file.count - 3 + 1
        $host_file = $host_file[0..($host_file.count - $index_to_silce)]
    }
    $host_file += "$ipadd_control control"
    $host_file += "$ipadd_worker01 worker01"
    $host_file += "$ipadd_control worker02"
    Set-Content -Path $file -Value $host_file -Force
}

vagrant ssh control -c "sudo cp /sync/hosts /etc/hosts"
vagrant ssh control -c "sudo apt-get install ansible -y"
vagrant ssh control -c "sudo apt-get install sshpass -y"
vagrant ssh control -c "sudo cp /sync/ansible/ansible.cfg ~/.ansible.cfg"
vagrant ssh control -c "ansible-playbook -i /sync/ansible/myhosts /sync/ansible/playbook1.yml"
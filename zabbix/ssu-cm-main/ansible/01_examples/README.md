```
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts.ini playbook.yaml -vvvv
```

"ANSIBLE_HOST_KEY_CHECKING=False" is passing the host key checking.
so you encountered input situation, you should use "ANSIBLE_HOST_KEY_CHECKING=False".

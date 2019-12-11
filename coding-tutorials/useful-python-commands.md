# cool python command line tools

To uninstall all local user packages

```shell
pip uninstall -y -r <(pip freeze)
```

Generate a random-key (e.g for Django-Secret-Key)

```shell
python -c "import random; print(''.join([random.choice('abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)') for i in range(50)]))"
```

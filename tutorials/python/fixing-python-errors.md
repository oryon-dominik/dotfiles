
# Python 3.8 Errors after installation

Unofficial Windows Binaries for [Python Extension Packages](https://www.lfd.uci.edu/~gohlke/pythonlibs/)

## numpy & plotly-express

Installing [numpy + mkl](https://www.lfd.uci.edu/~gohlke/pythonlibs/#numpy) from `gohlkes pythonlibs` solves missing dll issues with plotly express.

## Pywin32

after
`pip install pywin32`

the error occures
`ImportError: DLL load failed while importing win32api: Das angegebene Modul wurde nicht gefunden.`

fix it with running the post install script
`C:\Python38\Scripts\pywin32_postinstall.py -install`

## Jupyter Notebook Asyncio

in `site-pacakges/tornado/tornado/platform/asyncio.py` enhance `import asyncio` with

```python
import asyncio
import sys
if sys.platform == 'win32' and sys.version_info > (3, 8, 0, 'alpha', 3) :
    asyncio.set_event_loop_policy(asyncio.WindowsSelectorEventLoopPolicy())
```

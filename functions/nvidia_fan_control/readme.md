## Set GPU fan speed via CLI 

I run PopOS + a 3060ti which has horrible fan congig out of the box. every X minutes it stars spinning like crazy. With this I can keep it idle. 

`fan 1-100` so `fan1 40` givs this output

```bash
fan1 40
Set GPU 0 fan speed to 40%
```

Same goes for `fan2` 

And to set both fans at the same time jsut type `fans 69`

```bash
fans 69
Set GPU 0 fan speed to 69%
Set GPU 1 fan speed to 69%
```
This does exactly the same as sliding the fan slider in nvidia X server settings. 

xxxx

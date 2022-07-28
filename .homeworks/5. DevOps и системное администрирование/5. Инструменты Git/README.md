1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.  
Ответ:  
Полный хеш коммита aefea: aefead2207ef7e2aa5dc81a34aedf0cad4c32545  
Комментарий коммита: Update CHANGELOG.md  
Команда для получения информации: `git show -s aefea`  

2. Какому тегу соответствует коммит 85024d3?
Ответ:  
Коммит 85024d3 соответствует тэгу: v0.12.23
Команда для получения информации: git describe --tags 85024d3
 
1. У коммта b8d720 два родителя: 56cd7859e и 9ea88f22f
Команда для получения информации:  git show -s --pretty=%p b8d720
 
4. Хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24 (включительно):
33ff1c03b (tag: v0.12.24) v0.12.24
b14b74c49 [Website] vmc provider links
3f235065b Update CHANGELOG.md
6ae64e247 registry: Fix panic when server is unreachable
5c619ca1b website: Remove links to the getting started guide's old location
06275647e Update CHANGELOG.md
d5f9411f5 command: Fix bug when using terraform login on Windows
4b6d06cc5 Update CHANGELOG.md
dd01a3507 Update CHANGELOG.md
225466bc3 Cleanup after v0.12.23 release
85024d310 (tag: v0.12.23) v0.12.23
Команда для получения информации: git log --oneline v0.12.23^...v0.12.24
 
5. Коммит в котором была создана функция func providerSource: 8c928e835
Команда для получения информации: git grep 'func providerSource' (для поиска файла с функцией) и git log -s --oneline --reverse -L :providerSource:provider_source.go (для поиска коммитов).
 
6. Коммиты в которых была изменена функция globalPluginDirs (за исключением первого, в котором она была добавлена):
78b122055
52dbf9483
41ab0aef7
66ebff90c
Команды для получения информации: git grep globalPluginDirs (для поиска файла) и git log -s --oneline -L :globalPluginDirs:plugins.go (для поиска коммитов).
 
7. Автор функции synchronizedWriters: Martin Atkins
Команда для получения информации: git log --reverse -p -S synchronizedWriters

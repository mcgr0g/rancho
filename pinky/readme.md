
# pinky server users
Вольные размышления на тему какие пользователи могут быть.

## business value
Допустим ты счастливый дата-аналитик (и временами несчастный админ) и у тебя следующая ситуация
* у тебя обслуживаются два отдела. Они могут конкурировать, так что считай 2 компании, которые ничего не должны знать про друг друга
* в каждой компании есть говорящая голова, она же многими считается [главарем](#header)
* у каждого главаря есть пара [замов](#vicars)
* у каждого зама есть свой доверенный задрот, банда разрабов, роботы и шестирукие шивы.  Ну тоесть это будет как то так:
  * [шивы](#shivas), 3 штуки
  * [доверенные люди](#trusks)
  * настоящие пираты своего дела - [бадеросы](#banderos). А вот у них в команде есть следующие кадры
    * [рукожопы](#pipboys) со своими любимыми костылями
  * роботы и техинческие пользователи:
    * [бендер](#benders) для запуска приложения
    * [дворецкий](#butlers) для раскатки приложения
    * [отчетник](#deputats) для рассылки статистики и уведомлений
    * [куцый](#stub) для авторизации

и всех их как то надо уместить на одном серваке, что бы они исполняли свои функции.

### header
Руководителю эта вся инженерка нахер не нужна, он в базуку если и заглянет то это будет раз, read типу пользователя `ringleader`. В проекте если он что то прочитает флаг ему в руги: `read`only. У нас их будет 2:
* `gomer`
* --
* `march`
Ну потому что и сами персонажи нихера не одупляют. Максимум могут скинуть доступы для субподряда, что бы оценили объем аврала.

### vicars
Замы, это такие ушленькие ребята, которые вроде бы могут все, но им дико лень и они отдают все задротам: в проекте снова только `read`, в биде их тоже надо по маленькому только пускать: `read`. У нас их будет соотвественно 4:
* `burt`
* `liza`
* --
* `alu`
* `ali`

Почему так? Да просто они трепыхаются но ничего сами не могут.

### shivas
Шивы, они на подхвате, но не стоит ожидать от них многого: контент подправят и какую-нибудь простую аналитику соберут запустив простой скрипт читают все в проекте и запускать что-нибудь локальное, ну то есть `rx`. Ходят в биде на `read`. Почему 3? Да все просто, они будут закрывать следующие функции:
* поправить сраные опечатки
* собрать ебучую статистику для главаря
* посмотреть какая ветка из гита накачена и нажаловаться кому-нибудь

Соотвественно у нас их будет 6:
* `kortana`
* `kate`
* `siri`
* --
* `buttheadd`
* `beavis`
* `gogi`

### trusks
Доверенные лица - нужные люди, читают, изменяют и исполняют все файлы  в проекте, шатают базуку как хотят с правами `rw`, а еще могут повышать привелегии, что бы ставить свои собственные костыли для себя или вообще для всех. Они и DevOps и dba'шники и просто люби с повышенной ответственностью. Будут:
* `nerd`
* `geek`
* --
* `pinky`
* `braniac`

### banderos
Это святочи на проекте, rwx все на проекте, судоеры. В базуку вваливаются с правами `rw`. Участники 
* `antonio`
* `harvy`
* --
* `rick`
* `morty`

### pipboys
 Ну рукожопов видели все, могут rw на проекте, а вот а базуку они ходят по маленькому, только на `r`. Думаю, тут не надо особо изголяться c участниками:
* `rukojop`
* `guboshlep`
* `guginot`
* `abdurohman`
* `adebizi`
* `kumar`
* --
* `miracleman`
* `biomaterial`
* `jerrysmith`
* `pitergriffin`
* `flintsoun`
* `luislitt`

### benders
Никто бы не подумал но на этом чуваке все держится, он как супервизор может поднимать вассалов и обрабатывать запросы и прочую херь. Обычно их конфигурят бандеросы, когда их зеабывает на пятый раз делать одно и тоже В биде ходит по большому на `rw`, да и вот в проекте может все: `rwx`. Настоящее зло должны знать по имени:
* `bender`
* * --
* `prapor`

### butlers
На дворецком всякая полезная поебень, без которой жить можно, но куда лучше с ним: дампы, накаты и прочую важную хуйню. В биде ходит по большому на `rw`, может а проекте `rwx`.Будем величать так
* `butler`
* --
* `jemadar`

### deputats
Депутаты вроде бы нахуй не нужены по началу, но он делает всякие отчеты. Ходит в биде по маленькому на `r`, в проекте может rx. Ну как бы тут сам бог велел:
* `report-man`
* --
* `account-man`

### stub
Куцый пользователь может пригодиться совершенно неожиданно: авторизоваться, если проебал ssh ключи, пробросить порты и попырчить что-нибудь. В биде не ходит, читать ничего не должен.

## first view
ну как мы видим есть 2 типа использования сервака: файлуха и базука. Окей гугл, погнали.

| groups   | db grants | fs chmod |
|:---------|:----------|:---------|
| header   | r         | r        |
| shivas   | r         | rx       |
| trusks   | rw        | rwx      |
| banderos | rw        | rwx      |
| pipboys  | r         | rw       |
| benders  | rw        | rwx      |
| butlers  | rw        | rwx      |
| deputats | r         | rx       |
| stub     | --        | --       |

Достаточно странно, что у нас пересекаются права у пары групп. Но это потому что это просто первое приближение, надо рассматривать детальнее в разрезе схем и сред исполнения.


## database structure
Как ни странно, но начнем с нее, потому что тут довольно просто. У нас будет следующая логика раскладывания информации в 
* `data` схема (table space) с данными в реал-тайме изменающимися
    * `users` - пользаки
    * `sessions` - сесссии или токены авторизации
    * `operations` -  текущие состояние операций
* `conf` - в пердставлении не нуждается. Вот только нужно четко понимать что следует хранить в БД, а что в фпйле. Пассы - в базуку.
    * `migration` - правила и логи миграции БД, сюда можно сувать тело пакета как blob и результат миграции
    * `static` - какая-нибудь срань, если ее нужно хранить именно в БД. Бывает же хотят геренить html на лету.
    * `env`- фишки в настройках среды. Это если неоходимо перекофигурировать работу службы на лету. Но лучше осовить хренение конфигов в YAML и обновлять их из гита.
    * `points` - адреса, возможно относительные для внешних служб или внутренних микро-сервисов. Таже же топлю за то, что бы хранить их на файлухе
    * `auth` - параметры авторизации сервисов
* `mdm` - схема с нормативно-справочная информация, словари и прочая херабора, которая может изменяться раз в год. Очень похожа на конфиги, но ее нельзя править кому попало, потому что валяется там полу-бизнесовые фигли
    * `user_groups` - типы пользаков. Имеет смысл сделать иерархию в группах.
    * `operation_types` - типы операций. Вот все что угодно
    * `workflow` - вот это хитрая поебень. Можно в блобе хранить правила работы бизнес-процесса на каком-нибудь псевдо языке.
* `log` схема с локальными логами. Лучше отдельный инстанс, что бы не утилизировать можности основной базы опционально стоит поделить на следующие
    * `operations` с логами по работе сервака, с принятыми логическими решениями и прочей фигней
    * `auth` логи авторизаций. Нужны совершенно внезапно.
    * `import` с интеграционными логами по импорту
    * `export` ну думаю все понятно
* `report` - свалка для отчетов

## database grants

### dev
На деве вообще можно дать всем послабления

| group  | header | shivas | trusks | banderos | pipboys | benders | butlers | deputats |
|:-------|:-------|:-------|:-------|:---------|:--------|:--------|:--------|:---------|
| data   | r      | rw     | rw     | rw       | rw      | rw      | r       | r        |
| mdm    | r      | rw     | rw     | rw       | rw      | rw      | r       | r        |
| conf   | r      | rw     | rw     | rw       | rw      | rw      | r       | r        |
| log    | r      | rw     | rw     | rw       | rw      | rw      | rw      | r        |
| report | r      | rw     | rw     | rw       | rw      | rw      | rw      | r        |

### stage
На стэйдже это будет как то так

| group  | header | shivas | trusks | banderos | pipboys | benders | butlers | deputats |
|:-------|:-------|:-------|:-------|:---------|:--------|:--------|:--------|:---------|
| data   | r      | r      | rw     | rw       | r       | rw      | r       | r        |
| mdm    | r      | r      | rw     | rw       | r       | rw      | r       | r        |
| conf   | r      | r      | rw     | rw       | rw      | rw      | r       | r        |
| log    | r      | r      | r      | rw       | r       | rw      | rw      | r        |
| report | r      | rw     | rw     | rw       | r       | rw      | rw      | r        |


### prod
А вот в продакшене - полный тоталитаризм

| group  | header | shivas | trusks | banderos | pipboys | benders | butlers | deputats |
|:-------|:-------|:-------|:-------|:---------|:--------|:--------|:--------|:---------|
| data   | r      | r      | rw     | rw       | -       | rw      | r       | r        |
| mdm    | r      | r      | rw     | rw       | r       | rw      | r       | r        |
| conf   | r      | r      | rw     | rw       | r       | rw      | r       | r        |
| log    | r      | r      | r      | rw       | r       | rw      | rw      | r        |
| report | r      | r      | rw     | rw       | r       | rw      | rw      | r        ||

Как видно, у всех групп меняются права в зависимости от среды. По этому их так много.

## project structure

все это дело будет валяться где нибуть в `/srv/project/magaz`

* `src/` - исхода
    * `abstact/` - всякие велосипеды для переиспользования
    * `apps/` - приложни
    * `run/` - хитрые скрипты для поднятия виртуального окружения, костылей и прочего
    * `api/` - костыли, что бы интегрироваться с кем-нибудь
    * `reports/` - несчастные отчеты
* `conf/` - конфиги
* `migration/` - скрипты для миграции БД
    * `scipts/` - вот прям миграции
    * `hooks/` - хуки для гита или баша
* `logs/` - не точно бы я рад это здесь хранить, но внутри можно насувать символьные ссылки на отдельные куски системы. Будут регулярно чиститься
    * `apps/` - логи приложений, можно сим
    * `web` - логи сервера
    * `migrations` - логи миграций
* `templates/` - шаблоны html, печатных форм, если это rtf
    * `html/`
    * `css/`
    * `js/`
    * `printform/`
* `static/` - картинки и все что загружается конечными пользователями
    * `img/` - пикчи
    * `video/` - видосики
    * `repots/` - всякие csv от  отчетов, которые неожиданно могут пригодиться
    * `store/` - вская хрень, которую не удалось категоризировать
* `test/` - эта папка внезапно даже может когда-нибудь наполниться
* `docs/` - и эта тоже
* `dumps/` - тут и дампы БД и просто выгрузки
* `pkg/` - какие нибудь модные фреймворки
* `lib/` - отдельные библиотеки или модули
* `bin/` - ну бинари.
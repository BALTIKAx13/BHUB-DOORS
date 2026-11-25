local function BHubInterface()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local UIS = game:GetService("UserInputService")
    local TS = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")
    local LP = Players.LocalPlayer

    local IS_MOBILE = false
    pcall(function() IS_MOBILE = UIS.TouchEnabled and (not UIS.KeyboardEnabled or not UIS.MouseEnabled) end)

    local HUB_TITLE = "BHUB DOORS"
    local TAG_LINE_1 = "BEST FREE DOORS SCRIPT"
    local TAG_LINE_2 = "BALTIKA HUB DOORS"
    local DISCORD_LINK = "https://discord.gg/dt5PhHhNX"
    local DISCORD_SHORT = ".gg/dt5PhHhNX"

    local COLORS = {
        bg = Color3.fromRGB(5, 5, 8),
        panel = Color3.fromRGB(12, 12, 15),
        row = Color3.fromRGB(18, 18, 22),
        row2 = Color3.fromRGB(30, 30, 35),
        stroke = Color3.fromRGB(200, 200, 210),
        strokeSoft = Color3.fromRGB(60, 60, 60),
        white = Color3.fromRGB(245, 245, 247),
        text = Color3.fromRGB(228, 228, 236),
        dim = Color3.fromRGB(170, 170, 180),
        accent = Color3.fromRGB(245, 245, 247),
        accentStrong = Color3.fromRGB(220, 230, 240),
        good = Color3.fromRGB(100, 220, 160),
        risky = Color3.fromRGB(255, 110, 120),
    }

    local THEMES = {
        { name = "BLUE", color = Color3.fromRGB(58, 128, 245) },
        { name = "PURPLE", color = Color3.fromRGB(170, 80, 255) },
        { name = "PINK", color = Color3.fromRGB(255, 90, 200) },
        { name = "YELLOW", color = Color3.fromRGB(255, 214, 0) },
        { name = "WHITE", color = Color3.fromRGB(245, 245, 247) },
    }
    local themeHooks = {}
    local function onTheme(fn) themeHooks[#themeHooks + 1] = fn end

    local CONFIG_PATH = "BHUB rework/Games/Doors/BHUBDOORS.json"
    pcall(function()
        if type(makefolder) == "function" and type(isfolder) == "function" then
            if not isfolder("BHUB rework") then makefolder("BHUB rework") end
            if not isfolder("BHUB rework/Games") then makefolder("BHUB rework/Games") end
            if not isfolder("BHUB rework/Games/Doors") then makefolder("BHUB rework/Games/Doors") end
        end
    end)

    local SavedData = {}
    pcall(function()
        if type(isfile) == "function" and isfile(CONFIG_PATH) then
            local d = HttpService:JSONDecode(readfile(CONFIG_PATH))
            if type(d) == "table" then SavedData = d end
        end
    end)

    local UISet = {
        themeName = "WHITE",
        bgI = 0.58,
        guiScale = 1,
        noIntro = false,
        headTag = true,
        locked = false,
    }
    do
        local su = SavedData.ui
        if type(su) == "table" then
            if type(su.themeName) == "string" then UISet.themeName = su.themeName end
            if type(su.bgI) == "number" then UISet.bgI = math.clamp(su.bgI, 0, 1) end
            if type(su.guiScale) == "number" then UISet.guiScale = math.clamp(su.guiScale, 0.6, 1.6) end
            if type(su.noIntro) == "boolean" then UISet.noIntro = su.noIntro end
            if type(su.headTag) == "boolean" then UISet.headTag = su.headTag end
            if type(su.locked) == "boolean" then UISet.locked = su.locked end
        end
    end
    local function themeColor()
        for _, t in ipairs(THEMES) do
            if t.name == UISet.themeName then return t.color end
        end
        return THEMES[#THEMES].color
    end
    local function applyTheme()
        local c = themeColor()
        COLORS.accent = c
        for _, fn in ipairs(themeHooks) do pcall(fn, c) end
    end

    local function dummyControl()
        local d = { Value = nil, Mode = "Toggle" }
        function d:OnChanged(_) end
        function d:SetValue(_) end
        function d:SetValueRGB(_) end
        function d:GetState() return false end
        function d:AddKeyPicker(_) return dummyControl() end
        function d:AddColorPicker(_) return dummyControl() end
        return d
    end
    local toggleDummies, optionDummies = {}, {}
    local safeToggles = setmetatable({}, { __index = function(_, k)
        if not toggleDummies[k] then
            toggleDummies[k] = dummyControl()
            toggleDummies[k].Value = false
        end
        return toggleDummies[k]
    end })
    local safeOptions = setmetatable({}, { __index = function(_, k)
        if not optionDummies[k] then optionDummies[k] = dummyControl() end
        return optionDummies[k]
    end })

    local Library = {
        Toggles = safeToggles,
        Options = safeOptions,
        IsMobile = IS_MOBILE,
        LiveNotifications = true,
        Scheme = {
            BackgroundColor = COLORS.bg,
            MainColor = COLORS.panel,
            AccentColor = themeColor(),
            OutlineColor = COLORS.stroke,
            FontColor = COLORS.text,
            Font = Enum.Font.GothamBold,
        },
        Unloaded = false,
    }
    onTheme(function(c) Library.Scheme.AccentColor = c end)
    applyTheme()

    UISet.lang = "EN"
    do
        local su = SavedData.ui
        if type(su) == "table" and su.lang == "RU" then UISet.lang = "RU" end
    end

    local LANG_RU = {
        ["Aggression "] = "Агрессия ", ["Ambient"] = "Фон", ["Anchor ["] = "Якорь [",
        ["Anti Closet Trash"] = "Анти мусор в шкафу", ["Anti Noise"] = "Анти шум", ["Anti Ransom"] = "Анти выкуп",
        ["Anticheat Bypass"] = "Обход античита", ["Appearance"] = "Внешний вид", ["Archives"] = "Архивы",
        ["Arrow Radius"] = "Радиус стрелок", ["Audio"] = "Звук", ["Auto"] = "Авто",
        ["Auto Breaker Box"] = "Авто щиток", ["Auto Breaker Room"] = "Авто комната щитка", ["Auto Closet"] = "Авто шкаф",
        ["Auto Complete Cringle"] = "Авто Cringle", ["Auto Complete Dam Seek"] = "Авто дамба (Сик)",
        ["Auto Heartbeat Minigame"] = "Авто сердцебиение", ["Auto Hotel"] = "Авто Отель",
        ["Auto Interact"] = "Авто взаимодействие", ["Auto Join Elevator"] = "Авто вход в лифт",
        ["Auto Library"] = "Авто библиотека", ["Auto Rooms"] = "Авто Комнаты",
        ["Auto Solve Anchors"] = "Авто якоря", ["Auto Steer Minecart"] = "Авто вагонетка",
        ["Auto Tp Next Door"] = "Авто ТП к след. двери", ["Auto Unlock Padlock"] = "Авто взлом замка",
        ["Automation"] = "Автоматизация", ["BG Intensity"] = "Яркость фона",
        ["Battle Mode"] = "Боевой режим", ["Bramble"] = "Брамбл",
        ["Bring Dropped Candy"] = "Принести выпавшие конфеты", ["Bring Dropped Items"] = "Принести выпавшие предметы",
        ["Bug Out Creak (Requires ≥5 Cart)"] = "Выбить Крика (нужно ≥5 тележек)",
        ["Bypass"] = "Обход", ["Bypass / Solve"] = "Обход / Решение", ["Bypass Alma"] = "Обход Альмы",
        ["Bypass Banana"] = "Обход банана", ["Bypass Drones"] = "Обход дронов", ["Bypass Dupe"] = "Обход Дюпа",
        ["Bypass Electric Water"] = "Обход электро-воды", ["Bypass Eyes"] = "Обход Глаз",
        ["Bypass Giggle"] = "Обход Гиггла", ["Bypass Gloombat Eggs"] = "Обход яиц Глумбата",
        ["Bypass Jeff"] = "Обход Джеффа", ["Bypass Killbricks"] = "Обход киллбриков",
        ["Bypass Lookman"] = "Обход Лукмана", ["Bypass Scribbles"] = "Обход Скрибблс",
        ["Bypass Seek Obstructions"] = "Обход препятствий Сика", ["Bypass Seeking Wall"] = "Обход стены Сика",
        ["Bypass Snare"] = "Обход Снейра", ["Bypass Vacuum"] = "Обход вакуума", ["Bypasses"] = "Обходы",
        ["Camera"] = "Камера", ["Camera / Effects"] = "Камера / Эффекты", ["Candy Farm"] = "Фарм конфет",
        ["Candy Magic"] = "Магия конфет", ["Cellar"] = "Погреб", ["Character"] = "Персонаж",
        ["Chests"] = "Сундуки", ["Completion"] = "Прохождение", ["Config"] = "Конфиг",
        ["Copy Death Farm Loadstring"] = "Копировать фарм смертей", ["Copy Discord"] = "Копировать Discord",
        ["Copy Discord  "] = "Копировать Discord  ",
        ["Correct Box ESP/Auto Interact"] = "ESP верного ящика/авто",
        ["Creak Aggression Meter"] = "Шкала агрессии Крика", ["Crouch Distance"] = "Дистанция красться",
        ["Crouch Spoof"] = "Подмена приседа", ["Currency"] = "Валюта", ["Custom FOV"] = "Свой FOV",
        ["Custom Fov"] = "Свой FOV", ["Cycle Achievements"] = "Прокрутка достижений", ["Cycle Delay"] = "Задержка цикла",
        ["Death"] = "Смерть", ["Debug"] = "Отладка", ["Delete Crushers"] = "Удалить дробилки",
        ["Delete Figure"] = "Удалить Фигуру", ["Delete Seek Trigger"] = "Удалить триггер Сика",
        ["Died to BHUB"] = "Умер от BHUB", ["Died to Verity"] = "Умер от Verity",
        ["Disable Crushers"] = "Отключить дробилки", ["Disable Entity Jumpscares"] = "Отключить скримеры энтити",
        ["Disable Firedamp Effect"] = "Отключить эффект газа", ["Disable Glitch Jumpscare"] = "Отключить скример Глитча",
        ["Disable Hide Vignette"] = "Отключить виньетку Хайда", ["Disable Idle Kick"] = "Отключить кик за АФК",
        ["Disable Timothy Jumpscare"] = "Отключить скример Тимоти", ["Disable Void Jumpscare"] = "Отключить скример Войда",
        ["Distance"] = "Дистанция", ["Door "] = "Дверь ", ["Door Key"] = "Ключ от двери",
        ["Door Reach"] = "Досягаемость дверей", ["Doors"] = "Двери", ["Dupe"] = "Дюп",
        ["ESP Settings"] = "Настройки ESP", ["Effects"] = "Эффекты", ["Electrical Key"] = "Электро ключ",
        ["Enable Arrows"] = "Включить стрелки", ["Enable Interval"] = "Включить интервал",
        ["Enable Jumping"] = "Включить прыжки", ["Enable Sliding"] = "Включить скольжение",
        ["Enable Speed Boost"] = "Включить ускорение", ["Enable Tracers"] = "Включить трасеры",
        ["Entities"] = "Энтити", ["Entities / Settings / Entity Nodes"] = "Энтити / Настройки / Ноды",
        ["Entity List"] = "Список энтити", ["Exit Closet"] = "Выход из шкафа", ["Experimental"] = "Экспериментально",
        ["Exploits"] = "Эксплойты", ["Exploits / Anti"] = "Эксплойты / Анти",
        ["Exploits / Anti / Misc"] = "Эксплойты / Анти / Разное", ["Eyestalk Path"] = "Путь айстока",
        ["Fade Time"] = "Время затухания", ["Farming"] = "Фарм",
        ["Features highlighted in red are risky / dont work in the current floor."] = "Красное — рискованно / не работает на этом этаже.",
        ["Features highlighted in red are risky."] = "Красным выделены рискованные функции.",
        ["Field of View"] = "Поле зрения", ["Figure"] = "Фигура", ["Figure Godmode"] = "Годмод от Фигуры",
        ["Fih Tank"] = "Аквариум", ["Fill Transparency"] = "Прозрачность заливки", ["Fire Alarm"] = "Пожарная тревога",
        ["Floors"] = "Этажи", ["Fly"] = "Полёт", ["Fly Speed"] = "Скорость полёта",
        ["Forget Me Not Skipper"] = "Скип Forget Me Not", ["Fuse Breaker"] = "Предохранитель",
        ["GUI Size"] = "Размер GUI", ["Garage Door"] = "Гаражная дверь", ["Gate Button"] = "Кнопка ворот",
        ["Gate Lever"] = "Рычаг ворот", ["General"] = "Главная", ["Generator"] = "Генератор",
        ["Generator Fuse"] = "Предохранитель генератора", ["Get Current Floor"] = "Текущий этаж",
        ["Get Current Room"] = "Текущая комната", ["Giggle"] = "Гиггл", ["Gloombat Eggs"] = "Яйца Глумбата",
        ["Gold Pile ["] = "Золото [", ["Green Herb"] = "Зелёная трава", ["Groundskeeper"] = "Смотритель",
        ["Grumble"] = "Грамбл", ["Guess Library Code"] = "Угадать код библиотеки", ["Halloween"] = "Хэллоуин",
        ["Height"] = "Высота", ["Hiding Spots"] = "Укрытия", ["Hint Book"] = "Книга-подсказка",
        ["Hint Paper"] = "Записка-подсказка", ["Hotel-"] = "Отель-", ["Ignore A-60"] = "Игнор А-60",
        ["Ignore Entities"] = "Игнорировать энтити", ["Ignore List"] = "Список игнора",
        ["Infinite Crucifix"] = "Бесконечное распятие", ["Infinite Items"] = "Бесконечные предметы",
        ["Infinite Jumps"] = "Бесконечные прыжки", ["Infinite Revives"] = "Бесконечные возрождения",
        ["Info"] = "Инфо", ["Instant Prompts"] = "Мгновенные промпты", ["Interval"] = "Интервал",
        ["Item List"] = "Список предметов", ["Item Number"] = "Номер предмета", ["Items"] = "Предметы",
        ["Items: "] = "Предметы: ", ["Keep Notifications"] = "Не скрывать уведомления",
        ["Kill All (Requires ≥1 Cart)"] = "Убить всех (нужна ≥1 тележка)", ["Knob Farm"] = "Фарм ручек",
        ["Ladder"] = "Лестница", ["Ladder Softlock Fix"] = "Фикс софтлока лестницы", ["Ladders"] = "Лестницы",
        ["Line Thickness"] = "Толщина линии", ["Line Transparency"] = "Прозрачность линии",
        ["Lock GUI"] = "Заблокировать GUI", ["Locked Item Locker"] = "Закрытый шкафчик", ["Main"] = "Главная",
        ["Mandrake Hole"] = "Нора мандрагоры", ["Manipulation Method"] = "Метод манипуляции", ["Menu"] = "Меню",
        ["Message"] = "Сообщение", ["Mirror"] = "Зеркало", ["Misc"] = "Разное", ["Miscellaneous"] = "Разное",
        ["Mouse"] = "Мышь", ["New - Halloween"] = "Новое - Хэллоуин", ["No A-90 Damage"] = "Без урона А-90",
        ["No Halt Damage"] = "Без урона Халта", ["No Intro"] = "Без интро", ["No Screech Damage"] = "Без урона Скрича",
        ["No Surge Damage"] = "Без урона Сёрджа", ["Noclip"] = "Ноклип", ["Node Transparency"] = "Прозрачность нод",
        ["Noise Tv Breaker"] = "Шум: ТВ-щиток", ["Notify Chat"] = "Уведомления в чат",
        ["Notify Entities"] = "Уведомлять об энтити", ["Notify Haste Time"] = "Время Хейста",
        ["Notify Items"] = "Уведомлять о предметах", ["Notify Library Code"] = "Код библиотеки",
        ["Notify Oxygen Level"] = "Уровень кислорода", ["Notify Style"] = "Стиль уведомлений",
        ["Objectives"] = "Цели", ["Orbit Dropped Items"] = "Орбита выпавших предметов",
        ["Outline Transparency"] = "Прозрачность контура", ["Overhead Text"] = "Текст над головой",
        ["Package Deposit"] = "Сдача посылки", ["Path"] = "Путь", ["Pathfind Timeout"] = "Таймаут поиска пути",
        ["Play Again"] = "Играть снова", ["Play Sound"] = "Проиграть звук", ["Players"] = "Игроки",
        ["Players / Monsters"] = "Игроки / Монстры", ["Position Spoof"] = "Подмена позиции", ["Present"] = "Подарок",
        ["Prompt Clip"] = "Промпт сквозь стены", ["Prompt Reach Multiplier"] = "Дальность промпта",
        ["Quick Play"] = "Быстрая игра", ["Rainbow Effect"] = "Радужный эффект", ["Remove"] = "Удаление",
        ["Remove A-90"] = "Удалить А-90", ["Remove Acceleration"] = "Убрать ускорение",
        ["Remove Basement Gate"] = "Убрать решётку подвала", ["Remove Camera Bobbing"] = "Убрать качание камеры",
        ["Remove Camera Shake"] = "Убрать тряску камеры", ["Remove Closet Delay"] = "Убрать задержку шкафа",
        ["Remove Cutscenes"] = "Убрать катсцены", ["Remove Dread"] = "Убрать Дреда",
        ["Remove Extra Fog"] = "Убрать лишний туман", ["Remove Fog"] = "Убрать туман",
        ["Remove Footstep Sounds"] = "Убрать звуки шагов", ["Remove Halt"] = "Убрать Халта",
        ["Remove Interacting Sounds"] = "Убрать звуки взаимодействия", ["Remove Jammin Music"] = "Убрать музыку Jammin",
        ["Remove Meld"] = "Убрать Мелда", ["Remove Paintings Door"] = "Убрать дверь с картинами",
        ["Remove Screech"] = "Убрать Скрича", ["Remove Skeleton Door"] = "Убрать дверь-скелет",
        ["Remove Surge"] = "Убрать Сёрджа", ["Render Limit"] = "Лимит рендера", ["Reset Character"] = "Сбросить персонажа",
        ["Retro Mode"] = "Ретро режим", ["Return to Lobby"] = "Вернуться в лобби", ["Revive"] = "Возродиться",
        ["Rush Mode"] = "Режим Раша", ["Save Config"] = "Сохранить конфиг", ["Scrapper"] = "Скраппер",
        ["Seek Path"] = "Путь Сика", ["Self"] = "Персонаж", ["Settings"] = "Настройки",
        ["Shopping Cart"] = "Тележка", ["Shopping Cart Target"] = "Цель тележки", ["Show Distance"] = "Показ дистанции",
        ["Show Entity Path"] = "Показ пути энтити", ["Show Eyestalk Path"] = "Показ пути айстока",
        ["Show Path"] = "Показывать путь", ["Show Seek Path"] = "Показ пути Сика", ["Skip Cutsenes"] = "Пропуск катсцен",
        ["Skip Seek (Hotel)"] = "Скип Сика (Отель)", ["Skip Seek (Mines)"] = "Скип Сика (Шахты)", ["Snare"] = "Снейр",
        ["Sound Volume"] = "Громкость звука", ["Spectate Entity"] = "Наблюдать за энтити", ["Speed"] = "Скорость",
        ["Speed Boost"] = "Ускорение", ["Spoof Footsteps"] = "Подмена шагов", ["Stairwell"] = "Лестничная клетка",
        ["Stardust Pile"] = "Куча звёздной пыли", ["Start Death Farm"] = "Старт фарма смертей",
        ["Start Knob Farm"] = "Старт фарма ручек", ["Stop Time/Anti Stampede"] = "Стоп время/Анти давка",
        ["Super Hard Mode"] = "Супер-сложный режим", ["TP All Drops to Nearest Grinder"] = "ТП дропов к дробилке",
        ["TP to trash and drop trash."] = "ТП к мусору и выбросить.", ["Target"] = "Цель",
        ["Test Notification"] = "Тест уведомления", ["Text Font"] = "Шрифт текста",
        ["Text Outline Transparency"] = "Контур текста", ["Text Size"] = "Размер текста",
        ["Text Transparency"] = "Прозрачность текста", ["The Backdoor"] = "Задняя дверь", ["The Hotel"] = "Отель",
        ["The Mines"] = "Шахты", ["The Outdoors"] = "Улица",
        ["The Outdoors [Free, No Progress]"] = "Улица [бесплатно, без прогресса]", ["The Rooms"] = "Комнаты",
        ["The Rooms [Free, No Progress]"] = "Комнаты [бесплатно, без прогресса]", ["Third Person"] = "Третье лицо",
        ["Time Lever [+"] = "Рычаг времени [+", ["Time Shower"] = "Душ времени", ["Toolshed"] = "Сарай",
        ["Tp Next Door"] = "ТП к след. двери", ["Tracer Origin"] = "Источник трасеров",
        ["Tracer Thickness"] = "Толщина трасеров", ["Transparency"] = "Прозрачность",
        ["Transparent Hiding Spots"] = "Прозрачные укрытия", ["Turn Distance"] = "Дистанция поворота",
        ["Unload"] = "Выгрузить", ["Unlock Distance"] = "Дистанция разблокировки",
        ["Velocity Manipulation"] = "Манипуляция скоростью", ["Viewmodel Offset"] = "Смещение модели",
        ["Vine Chest"] = "Сундук с лозами", ["Vine Lever"] = "Рычаг с лозами", ["Visuals"] = "Визуалы",
        ["Void"] = "Войд", ["Wall Check"] = "Проверка стен", ["Water Pump"] = "Водяной насос",
        ["X Offset"] = "Смещение X", ["Y Offset"] = "Смещение Y", ["Z Offset"] = "Смещение Z",
        ["Menu Keybind"] = "Клавиша меню", ["Accent Color"] = "Цвет акцента", ["Language"] = "Язык",
        ["Config saved"] = "Конфиг сохранён", ["Keybind"] = "Клавиша",
        ["Keybinds need a keyboard"] = "На этом устройстве нет клавиатуры",
        ["Full translation after script restart"] = "Полный перевод — после перезапуска скрипта",
        ["Widget error: "] = "Ошибка виджета: ",
    }
    local LANG_REV = {}
    for k, v in pairs(LANG_RU) do LANG_REV[v] = k end
    local function tr(s)
        if UISet.lang == "RU" and type(s) == "string" then return LANG_RU[s] or s end
        return s
    end

    local main
    local miniBtn
    local saveQueued = false
    local function saveAll()
        if type(writefile) ~= "function" then return end
        if saveQueued then return end
        saveQueued = true
        task.delay(0.4, function()
            saveQueued = false
            pcall(function()
                local out = { toggles = {}, options = {}, ui = {
                    themeName = UISet.themeName,
                    bgI = UISet.bgI,
                    guiScale = UISet.guiScale,
                    noIntro = UISet.noIntro,
                    headTag = UISet.headTag,
                    locked = UISet.locked,
                    lang = UISet.lang,
                } }
                if main then
                    out.ui.hx = main.Position.X.Offset
                    out.ui.hy = main.Position.Y.Offset
                    out.ui.hxs = main.Position.X.Scale
                    out.ui.hys = main.Position.Y.Scale
                end
                if miniBtn then
                    out.ui.mx = miniBtn.Position.X.Offset
                    out.ui.my = miniBtn.Position.Y.Offset
                    out.ui.mxs = miniBtn.Position.X.Scale
                    out.ui.mys = miniBtn.Position.Y.Scale
                end
                for k, t in pairs(Library.Toggles) do
                    out.toggles[k] = t.Value == true
                end
                for k, o in pairs(Library.Options) do
                    local v = o.Value
                    if typeof(v) == "Color3" then
                        out.options[k] = { _c = true, r = v.R, g = v.G, b = v.B }
                    elseif type(v) == "table" then
                        local ok2, enc = pcall(function() return HttpService:JSONDecode(HttpService:JSONEncode(v)) end)
                        if ok2 then out.options[k] = enc end
                    elseif type(v) == "number" or type(v) == "string" or type(v) == "boolean" then
                        out.options[k] = v
                    end
                end
                writefile(CONFIG_PATH, HttpService:JSONEncode(out))
            end)
        end)
    end

    local function savedToggle(idx)
        local s = SavedData.toggles
        if type(s) == "table" and s[idx] ~= nil then return s[idx] == true end
        return nil
    end
    local function savedOption(idx)
        local s = SavedData.options
        if type(s) == "table" and s[idx] ~= nil then
            local v = s[idx]
            if type(v) == "table" and v._c then return Color3.new(v.r, v.g, v.b) end
            return v
        end
        return nil
    end

    local GUI = Instance.new("ScreenGui")
    GUI.Name = "BHUBDOORS"
    GUI.ResetOnSpawn = false
    GUI.IgnoreGuiInset = true
    GUI.DisplayOrder = 999
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        local old = game:GetService("CoreGui"):FindFirstChild("BHUBDOORS")
        if old then old:Destroy() end
    end)
    pcall(function()
        if type(gethui) == "function" then GUI.Parent = gethui() end
    end)
    if not GUI.Parent then
        pcall(function() GUI.Parent = game:GetService("CoreGui") end)
    end
    if not GUI.Parent then
        pcall(function() GUI.Parent = LP:WaitForChild("PlayerGui") end)
    end
    pcall(function()
        if type(protectgui) == "function" then protectgui(GUI) end
    end)

    local function applyLang()
        local toRU = UISet.lang == "RU"
        for _, el in ipairs(GUI:GetDescendants()) do
            if el:IsA("TextLabel") or el:IsA("TextButton") then
                local t = el.Text
                if toRU and LANG_RU[t] then
                    el.Text = LANG_RU[t]
                elseif (not toRU) and LANG_REV[t] then
                    el.Text = LANG_REV[t]
                end
            end
        end
    end

    local function corner(o, r)
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, r)
        c.Parent = o
        return c
    end
    local function stroke(o, col, th, tr)
        local s = Instance.new("UIStroke")
        s.Color = col
        s.Thickness = th or 1
        s.Transparency = tr or 0.7
        s.Parent = o
        return s
    end
    local function mkText(parent, txt, size, color, bold)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Text = tr(txt or "")
        l.TextColor3 = color or COLORS.text
        l.Font = bold and Enum.Font.GothamBold or Enum.Font.GothamMedium
        l.TextSize = size or 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.ZIndex = 7
        l.Parent = parent
        return l
    end

    local notifHolder = Instance.new("Frame")
    notifHolder.Name = "Notifs"
    notifHolder.BackgroundTransparency = 1
    notifHolder.Size = UDim2.new(0, 260, 1, -20)
    notifHolder.Position = UDim2.new(1, -270, 1, -10)
    notifHolder.ZIndex = 50
    notifHolder.Parent = GUI
    local notifLayout = Instance.new("UIListLayout")
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notifLayout.Padding = UDim.new(0, 6)
    notifLayout.Parent = notifHolder

    local function doNotify(title, desc, t)
        if Library.Unloaded then return end
        task.spawn(function()
            local f = Instance.new("Frame")
            f.BackgroundColor3 = COLORS.panel
            f.BorderSizePixel = 0
            f.Size = UDim2.new(1, 0, 0, 46)
            f.ZIndex = 51
            f.BackgroundTransparency = 1
            f.Parent = notifHolder
            corner(f, 10)
            local st = stroke(f, COLORS.accent, 1.4, 0.4)
            st.Transparency = 1
            local tl = mkText(f, tostring(title or "BHUB"), 12, COLORS.white, true)
            tl.Position = UDim2.new(0, 10, 0, 5)
            tl.Size = UDim2.new(1, -16, 0, 16)
            tl.TextTransparency = 1
            local dl = mkText(f, tostring(desc or ""), 11, COLORS.dim, false)
            dl.Position = UDim2.new(0, 10, 0, 22)
            dl.Size = UDim2.new(1, -16, 0, 16)
            dl.TextTransparency = 1
            TS:Create(f, TweenInfo.new(0.2), { BackgroundTransparency = 0.05 }):Play()
            TS:Create(st, TweenInfo.new(0.2), { Transparency = 0.4 }):Play()
            TS:Create(tl, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
            TS:Create(dl, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
            task.wait(tonumber(t) or 4)
            TS:Create(f, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
            TS:Create(st, TweenInfo.new(0.25), { Transparency = 1 }):Play()
            TS:Create(tl, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
            TS:Create(dl, TweenInfo.new(0.25), { TextTransparency = 1 }):Play()
            task.wait(0.3)
            f:Destroy()
        end)
    end

    function Library:Notify(a, b, c)
        if type(a) == "table" then
            doNotify(a.Title or a.Text or "BHUB", a.Description or a.Body or "", a.Time or a.Duration or 4)
        else
            doNotify(a, b, c)
        end
    end
    Library.BHubToast = doNotify

    main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 600, 0, 520)
    main.AnchorPoint = Vector2.new(1, 0.5)
    main.Position = UDim2.new(1, -8, 0.5, 0)
    do
        local su = SavedData.ui
        if type(su) == "table" and type(su.hx) == "number" then
            main.Position = UDim2.new(tonumber(su.hxs) or 1, su.hx, tonumber(su.hys) or 0.5, su.hy)
        end
    end
    main.BackgroundColor3 = COLORS.bg
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.ZIndex = 2
    main.Parent = GUI
    corner(main, 16)
    local mainStroke = stroke(main, themeColor(), 1.8, 0.2)
    task.spawn(function()
        local t0 = tick()
        while not Library.Unloaded and main.Parent do
            local t = tick() - t0
            local pulse = 0.5 + 0.5 * math.sin(t * 3.2)
            local boost = 0.12 * (0.5 + 0.5 * math.sin(t * 5.1 + 1.2))
            local col = themeColor()
            mainStroke.Color = Color3.new(math.clamp(col.R + boost, 0, 1), math.clamp(col.G + boost, 0, 1), math.clamp(col.B + boost, 0, 1))
            mainStroke.Thickness = 1.6 + pulse * 1.8
            mainStroke.Transparency = 0.08 + (1 - pulse) * 0.35
            task.wait(0.04)
        end
    end)

    local bgAsset = Instance.new("ImageLabel")
    bgAsset.Name = "BackgroundAsset"
    bgAsset.Size = UDim2.new(1, 0, 1, 0)
    bgAsset.BackgroundTransparency = 1
    bgAsset.ImageTransparency = 1
    bgAsset.ScaleType = Enum.ScaleType.Crop
    bgAsset.ZIndex = 0
    bgAsset.Parent = main
    corner(bgAsset, 14)
    local bgVeil = Instance.new("Frame")
    bgVeil.Name = "BackgroundVeil"
    bgVeil.Size = UDim2.new(1, 0, 1, 0)
    bgVeil.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
    bgVeil.BackgroundTransparency = 0.55
    bgVeil.BorderSizePixel = 0
    bgVeil.ZIndex = 1
    bgVeil.Parent = main
    corner(bgVeil, 14)
    local function applyBg()
        bgAsset.ImageTransparency = bgAsset.Image ~= "" and (1 - UISet.bgI) or 1
    end
    local miniBg = nil
    task.spawn(function()
        pcall(function()
            if type(getcustomasset) ~= "function" then return end
            local path = "BALTIKAHUB/bg1.jpg"
            local have = type(isfile) == "function" and isfile(path)
            if not have and type(writefile) == "function" then
                local data = game:HttpGet("https://raw.githubusercontent.com/BALTIKAx13/BHUB-DOORS/main/bg1.jpg")
                pcall(function()
                    if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder("BALTIKAHUB") then makefolder("BALTIKAHUB") end
                    writefile(path, data)
                end)
            end
            local img = getcustomasset(path)
            bgAsset.Image = img
            if miniBg then
                miniBg.Image = img
                miniBg.ImageTransparency = 0.12
            end
            applyBg()
        end)
    end)

    local uiScale = Instance.new("UIScale")
    uiScale.Parent = main
    local scaleTween = nil
    local function targetScale()
        local cam = workspace.CurrentCamera
        local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
        local fit = math.min((vp.X - 16) / 600, (vp.Y - 20) / 520)
        local scale
        if IS_MOBILE then
            scale = math.clamp(fit, 0.45, 1)
        else
            scale = math.clamp(fit, 0.7, 1.05)
        end
        return math.clamp(scale * UISet.guiScale, 0.3, 1.8)
    end
    local function updateScale()
        if scaleTween then pcall(function() scaleTween:Cancel() end) scaleTween = nil end
        uiScale.Scale = targetScale()
    end
    pcall(function()
        workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(updateScale)
        local cam = workspace.CurrentCamera
        if cam then cam:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale) end
    end)
    updateScale()

    local hubTitle = mkText(main, HUB_TITLE, 17, Color3.fromRGB(255, 0, 0), true)
    hubTitle.Font = Enum.Font.GothamBlack
    hubTitle.Position = UDim2.new(0, 14, 0, 10)
    hubTitle.Size = UDim2.new(1, -130, 0, 24)

    local statsLbl = mkText(main, "FPS -- · -- ms", 11, COLORS.dim, true)
    statsLbl.TextXAlignment = Enum.TextXAlignment.Right
    statsLbl.Position = UDim2.new(1, -150, 0, 12)
    statsLbl.Size = UDim2.new(0, 106, 0, 20)
    task.spawn(function()
        local frames, last, smooth = 0, tick(), 0
        local Stats = game:GetService("Stats")
        pcall(function()
            RunService.RenderStepped:Connect(function() frames = frames + 1 end)
        end)
        while not Library.Unloaded and main.Parent do
            task.wait(0.4)
            local now = tick()
            if now - last <= 0 then continue end
            local inst = frames / (now - last)
            smooth = (smooth == 0) and inst or (smooth * 0.6 + inst * 0.4)
            frames = 0
            last = now
            local fps = math.floor(smooth + 0.5)
            local ping = 0
            pcall(function()
                local item = Stats.Network.ServerStatsItem["Data Ping"]
                if item then ping = tonumber(tostring(item:GetValueString()):match("%d+") or "0") or 0 end
            end)
            if ping == 0 then pcall(function() ping = math.floor(LP:GetNetworkPing() * 1000 + 0.5) end) end
            statsLbl.Text = string.format("FPS %d · %d ms", fps, ping)
            if fps >= 55 and ping < 120 then
                statsLbl.TextColor3 = Color3.fromRGB(100, 220, 160)
            elseif fps < 30 or ping > 200 then
                statsLbl.TextColor3 = Color3.fromRGB(255, 110, 120)
            else
                statsLbl.TextColor3 = COLORS.dim
            end
        end
    end)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -36, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    closeBtn.BackgroundTransparency = 0.15
    closeBtn.Text = "-"
    closeBtn.TextColor3 = themeColor()
    onTheme(function(c) closeBtn.TextColor3 = c end)
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 16
    closeBtn.BorderSizePixel = 0
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 8
    closeBtn.Parent = main
    corner(closeBtn, 7)
    stroke(closeBtn, COLORS.strokeSoft, 1, 0.45)

    local profileCard = Instance.new("Frame")
    profileCard.Size = UDim2.new(1, -16, 0, 62)
    profileCard.Position = UDim2.new(0, 8, 0, 40)
    profileCard.BackgroundColor3 = COLORS.panel
    profileCard.BackgroundTransparency = 0.12
    profileCard.BorderSizePixel = 0
    profileCard.ZIndex = 5
    profileCard.Parent = main
    corner(profileCard, 12)
    stroke(profileCard, COLORS.strokeSoft, 1.2, 0.25)
    local avatarBg = Instance.new("Frame")
    avatarBg.Size = UDim2.new(0, 46, 0, 46)
    avatarBg.Position = UDim2.new(0, 8, 0.5, -23)
    avatarBg.BackgroundColor3 = Color3.fromRGB(22, 22, 24)
    avatarBg.BorderSizePixel = 0
    avatarBg.ZIndex = 6
    avatarBg.Parent = profileCard
    corner(avatarBg, 10)
    local avatarStroke = stroke(avatarBg, themeColor(), 1.4, 0.25)
    onTheme(function(c) avatarStroke.Color = c end)
    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.new(1, -4, 1, -4)
    avatarImg.Position = UDim2.new(0, 2, 0, 2)
    avatarImg.BackgroundTransparency = 1
    avatarImg.ScaleType = Enum.ScaleType.Crop
    avatarImg.ZIndex = 7
    avatarImg.Parent = avatarBg
    corner(avatarImg, 8)
    task.spawn(function()
        local ok, thumb = pcall(function()
            return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        end)
        if ok and thumb and avatarImg.Parent then avatarImg.Image = thumb end
    end)
    local displayName = mkText(profileCard, tostring(LP.DisplayName or LP.Name), 14, COLORS.white, true)
    displayName.Position = UDim2.new(0, 64, 0, 11)
    displayName.Size = UDim2.new(1, -76, 0, 20)
    local userName = mkText(profileCard, "@" .. tostring(LP.Name), 11, COLORS.dim, false)
    userName.Position = UDim2.new(0, 64, 0, 32)
    userName.Size = UDim2.new(1, -76, 0, 16)

    local headerDiv = Instance.new("Frame")
    headerDiv.Size = UDim2.new(1, -32, 0, 1)
    headerDiv.Position = UDim2.new(0, 16, 0, 110)
    headerDiv.BackgroundColor3 = COLORS.stroke
    headerDiv.BackgroundTransparency = 0.55
    headerDiv.BorderSizePixel = 0
    headerDiv.ZIndex = 5
    headerDiv.Parent = main

    local pagesHolder = Instance.new("Frame")
    pagesHolder.Size = UDim2.new(1, -90, 1, -130)
    pagesHolder.Position = UDim2.new(0, 80, 0, 118)
    pagesHolder.BackgroundTransparency = 1
    pagesHolder.ZIndex = 3
    pagesHolder.ClipsDescendants = true
    pagesHolder.Parent = main

    local tabCol = Instance.new("Frame")
    tabCol.BackgroundTransparency = 1
    tabCol.Position = UDim2.new(0, 8, 0, 118)
    tabCol.Size = UDim2.new(0, 64, 1, -130)
    tabCol.ZIndex = 5
    tabCol.Parent = main
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.Parent = tabCol

    miniBtn = Instance.new("TextButton")
    miniBtn.Size = UDim2.new(0, 118, 0, 40)
    miniBtn.Position = UDim2.new(1, -128, 1, -50)
    do
        local su = SavedData.ui
        if type(su) == "table" and type(su.mx) == "number" then
            miniBtn.Position = UDim2.new(tonumber(su.mxs) or 1, su.mx, tonumber(su.mys) or 1, su.my)
        end
    end
    miniBtn.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    miniBtn.Text = ""
    miniBtn.ZIndex = 60
    miniBtn.BorderSizePixel = 0
    miniBtn.AutoButtonColor = false
    miniBtn.Visible = false
    miniBtn.ClipsDescendants = true
    miniBtn.Parent = GUI
    corner(miniBtn, 12)
    local miniStroke = stroke(miniBtn, themeColor(), 1.4, 0.35)
    onTheme(function(c) miniStroke.Color = c end)
    miniBg = Instance.new("ImageLabel")
    miniBg.BackgroundTransparency = 1
    miniBg.Size = UDim2.new(1, 0, 1, 0)
    miniBg.ScaleType = Enum.ScaleType.Crop
    miniBg.ImageTransparency = 1
    miniBg.ZIndex = 61
    miniBg.Parent = miniBtn
    corner(miniBg, 12)
    local miniShade = Instance.new("Frame")
    miniShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    miniShade.BackgroundTransparency = 0.55
    miniShade.BorderSizePixel = 0
    miniShade.Size = UDim2.new(1, 0, 1, 0)
    miniShade.ZIndex = 62
    miniShade.Parent = miniBtn
    corner(miniShade, 12)
    local miniText = Instance.new("TextLabel")
    miniText.BackgroundTransparency = 1
    miniText.Size = UDim2.new(1, 0, 1, 0)
    miniText.Text = "BHUB"
    miniText.TextColor3 = Color3.fromRGB(255, 255, 255)
    miniText.Font = Enum.Font.GothamBlack
    miniText.TextSize = 24
    miniText.TextStrokeTransparency = 0.35
    miniText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    miniText.ZIndex = 63
    miniText.Parent = miniBtn
    if bgAsset.Image ~= "" then
        miniBg.Image = bgAsset.Image
        miniBg.ImageTransparency = 0.12
    end

    local uiVisible = true
    local showTok = 0
    local function setUiVisible(v)
        uiVisible = v == true
        showTok = showTok + 1
        local my = showTok
        if uiVisible then
            main.Visible = true
            if scaleTween then pcall(function() scaleTween:Cancel() end) scaleTween = nil end
            local target = targetScale()
            uiScale.Scale = target * 0.85
            scaleTween = TS:Create(uiScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = target })
            scaleTween:Play()
            miniBtn.Visible = false
        else
            if scaleTween then pcall(function() scaleTween:Cancel() end) scaleTween = nil end
            local target = targetScale()
            scaleTween = TS:Create(uiScale, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Scale = target * 0.85 })
            scaleTween:Play()
            task.delay(0.18, function()
                if my ~= showTok then return end
                main.Visible = false
                uiScale.Scale = target
                miniBtn.Visible = true
            end)
        end
        saveAll()
    end
    closeBtn.MouseButton1Click:Connect(function() setUiVisible(false) end)
    do
        local miniDrag, miniStart, miniPos0, miniMoved = false, nil, nil, false
        miniBtn.InputBegan:Connect(function(inp)
            if UISet.locked then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                miniDrag = true
                miniMoved = false
                miniStart = inp.Position
                miniPos0 = miniBtn.Position
            end
        end)
        miniBtn.InputEnded:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if miniDrag and miniMoved then saveAll() end
                miniDrag = false
            end
        end)
        UIS.InputChanged:Connect(function(inp)
            if miniDrag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                local d = inp.Position - miniStart
                if math.abs(d.X) > 6 or math.abs(d.Y) > 6 then miniMoved = true end
                if miniMoved then
                    miniBtn.Position = UDim2.new(miniPos0.X.Scale, miniPos0.X.Offset + d.X, miniPos0.Y.Scale, miniPos0.Y.Offset + d.Y)
                end
            end
        end)
        miniBtn.MouseButton1Click:Connect(function()
            if miniMoved then miniMoved = false return end
            setUiVisible(true)
        end)
    end

    local headTag = nil
    local function removeHeadTag()
        if headTag and headTag.bb then pcall(function() headTag.bb:Destroy() end) end
        headTag = nil
        pcall(function()
            local ch = LP.Character
            local head = ch and ch:FindFirstChild("Head")
            local old = head and head:FindFirstChild("BHubHeadIndicator")
            if old then old:Destroy() end
        end)
    end
    local function buildHeadTag(char)
        removeHeadTag()
        if not UISet.headTag then return end
        char = char or LP.Character
        local head = char and (char:FindFirstChild("Head") or char:WaitForChild("Head", 5))
        if not head or not UISet.headTag or Library.Unloaded then return end
        local accent = themeColor()
        local bb = Instance.new("BillboardGui")
        bb.Name = "BHubHeadIndicator"
        bb.Size = UDim2.new(0, 240, 0, 118)
        bb.StudsOffset = Vector3.new(0, 3.6, 0)
        bb.ClipsDescendants = false
        bb.LightInfluence = 0
        bb.AlwaysOnTop = true
        bb.MaxDistance = 600
        bb.Adornee = head
        bb.Parent = head
        local function line(lname, text, y, font)
            local l = Instance.new("TextLabel")
            l.Name = lname
            l.Size = UDim2.new(1, 0, 0, 20)
            l.AnchorPoint = Vector2.new(0.5, 0.5)
            l.Position = UDim2.new(0.5, 0, 0, y)
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = accent
            l.Font = font
            l.TextSize = (lname == "Discord" or lname == "Speed") and 17 or 16
            l.TextStrokeTransparency = 0
            l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            l.Parent = bb
            return l
        end
        local best = line("BestFree", TAG_LINE_1, 12, Enum.Font.GothamBlack)
        local hname = line("HubName", TAG_LINE_2, 33, Enum.Font.GothamBlack)
        local discord = line("Discord", DISCORD_SHORT, 56, Enum.Font.GothamBold)
        local divider = Instance.new("Frame")
        divider.Name = "Divider"
        divider.Size = UDim2.new(0.62, 0, 0, 2)
        divider.AnchorPoint = Vector2.new(0.5, 0.5)
        divider.Position = UDim2.new(0.5, 0, 0, 75)
        divider.BackgroundColor3 = accent
        divider.BackgroundTransparency = 0.15
        divider.BorderSizePixel = 0
        divider.ZIndex = 2
        divider.Parent = bb
        corner(divider, 1).CornerRadius = UDim.new(1, 0)
        local speed = line("Speed", "Speed: 0.0", 94, Enum.Font.GothamBold)
        headTag = { bb = bb, labels = { best, hname, discord, speed }, divider = divider, speed = speed }
    end
    onTheme(function(c)
        if not headTag then return end
        for _, l in ipairs(headTag.labels) do
            if l and l.Parent then l.TextColor3 = c end
        end
        if headTag.divider and headTag.divider.Parent then headTag.divider.BackgroundColor3 = c end
    end)
    do
        local speedAcc, speedShown = 0, nil
        RunService.Heartbeat:Connect(function(dt)
            if Library.Unloaded then return end
            if not headTag or not headTag.speed or not headTag.speed.Parent then return end
            speedAcc = speedAcc + dt
            if speedAcc < 0.1 then return end
            speedAcc = 0
            local ch = LP.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            local v = 0
            if hrp then
                local vel = hrp.AssemblyLinearVelocity
                v = Vector3.new(vel.X, 0, vel.Z).Magnitude
            end
            local txt = string.format("Speed: %.1f", v)
            if txt ~= speedShown then
                speedShown = txt
                headTag.speed.Text = txt
            end
        end)
        LP.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if not Library.Unloaded and UISet.headTag then buildHeadTag(char) end
        end)
        if UISet.headTag then task.spawn(buildHeadTag) end
    end

    local function playIntro()
        local holder = Instance.new("Frame")
        holder.Name = "BHubIntro"
        holder.Size = UDim2.new(1, 0, 1, 0)
        holder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        holder.BackgroundTransparency = 1
        holder.BorderSizePixel = 0
        holder.ZIndex = 500
        holder.Parent = GUI
        local accent = themeColor()
        local function lbl(text, y, size, font, col)
            local l = Instance.new("TextLabel")
            l.AnchorPoint = Vector2.new(0.5, 0.5)
            l.Position = UDim2.new(0.5, 0, 0.5, y)
            l.Size = UDim2.new(1, -40, 0, size + 10)
            l.BackgroundTransparency = 1
            l.Text = text
            l.TextColor3 = col
            l.Font = font
            l.TextSize = size
            l.TextTransparency = 1
            l.TextStrokeTransparency = 1
            l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            l.ZIndex = 501
            l.Parent = holder
            return l
        end
        local labels = {
            lbl(TAG_LINE_1, -58, 22, Enum.Font.GothamBlack, accent),
            lbl(TAG_LINE_2, -24, 34, Enum.Font.GothamBlack, Color3.fromRGB(255, 0, 0)),
            lbl(DISCORD_LINK, 18, 18, Enum.Font.GothamBold, COLORS.white),
        }
        local fi = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TS:Create(holder, fi, { BackgroundTransparency = 0.35 }):Play()
        for i, l in ipairs(labels) do
            task.delay(0.12 * i, function()
                TS:Create(l, fi, { TextTransparency = 0, TextStrokeTransparency = 0.4 }):Play()
            end)
        end
        task.wait(2.4)
        local fo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TS:Create(holder, fo, { BackgroundTransparency = 1 }):Play()
        for _, l in ipairs(labels) do TS:Create(l, fo, { TextTransparency = 1, TextStrokeTransparency = 1 }):Play() end
        task.wait(0.45)
        holder:Destroy()
    end
    if not UISet.noIntro then task.spawn(playIntro) end

    UIS.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local mk = Library.Options.MenuKeybind
        local want = mk and mk.Value or "RightShift"
        local ok, kc = pcall(function() return Enum.KeyCode[want] end)
        if ok and kc and inp.KeyCode == kc then
            setUiVisible(not uiVisible)
        end
    end)

    do
        local drag, dragStart, startPos
        local function dragBegin(inp)
            if UISet.locked then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                drag = true
                dragStart = inp.Position
                startPos = main.Position
            end
        end
        local function dragEnd(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if drag then saveAll() end
                drag = false
            end
        end
        profileCard.InputBegan:Connect(dragBegin)
        profileCard.InputEnded:Connect(dragEnd)
        hubTitle.InputBegan:Connect(dragBegin)
        hubTitle.InputEnded:Connect(dragEnd)
        UIS.InputChanged:Connect(function(inp)
            if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                local d = inp.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    local allTabs = {}
    local activeTab = nil
    local anyListening = false

    local function fireCbs(obj, v)
        for _, cb in ipairs(obj._cbs) do
            task.spawn(function() pcall(cb, v) end)
        end
    end

    local popupClose = nil
    local function openPopup(height)
        if popupClose then pcall(popupClose) end
        local overlay = Instance.new("TextButton")
        overlay.Name = "PopupOverlay"
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.Position = UDim2.new(0, 0, 0, 0)
        overlay.BackgroundTransparency = 1
        overlay.Text = ""
        overlay.ZIndex = 69
        overlay.AutoButtonColor = false
        overlay.Parent = main
        local pop = Instance.new("Frame")
        pop.BackgroundColor3 = COLORS.panel
        pop.BorderSizePixel = 0
        pop.ZIndex = 70
        pop.Size = UDim2.new(0, 230, 0, height)
        pop.Position = UDim2.new(0.5, -115, 0.5, -height / 2)
        pop.Parent = main
        corner(pop, 10)
        stroke(pop, COLORS.accent, 1.4, 0.3)
        popupClose = function()
            if overlay.Parent then overlay:Destroy() end
            if pop.Parent then pop:Destroy() end
        end
        overlay.Activated:Connect(function()
            if popupClose then pcall(popupClose) end
            popupClose = nil
        end)
        return pop, popupClose
    end

    local function containerAdd(container, h)
        container._h = container._h + h + 4
        if container._sub then
            container._frame.Size = UDim2.new(1, 0, 0, container._h)
            if container._tabbox and container._tabbox._active == container then
                container._tabbox._frame.Size = UDim2.new(1, 0, 0, 34 + container._h + 6)
            end
        end
        if container._page then
            local sib = container._sib
            local other = (sib and sib._h) or 0
            container._page.CanvasSize = UDim2.new(0, 0, 0, math.max(container._h, other) + 18)
        end
    end

    local function mkRow(container, h)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, h or 34)
        row.BackgroundColor3 = COLORS.row
        row.BackgroundTransparency = 0.35
        row.BorderSizePixel = 0
        row.ZIndex = 4
        row.Parent = container._frame
        corner(row, 10)
        stroke(row, COLORS.stroke, 1, 0.82)
        row.MouseEnter:Connect(function()
            TS:Create(row, TweenInfo.new(0.12), { BackgroundTransparency = 0.08, BackgroundColor3 = COLORS.row2 }):Play()
        end)
        row.MouseLeave:Connect(function()
            local opt = row:GetAttribute("OptionActive")
            TS:Create(row, TweenInfo.new(0.12), {
                BackgroundTransparency = opt == true and 0.08 or (opt == false and 0.22 or 0.35),
                BackgroundColor3 = opt == true and COLORS.row:Lerp(themeColor(), 0.18) or COLORS.row,
            }):Play()
        end)
        containerAdd(container, h or 34)
        return row
    end

    local function rowLabel(row, txt)
        local l = mkText(row, txt, 12, COLORS.white, true)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.Size = UDim2.new(0.52, 0, 1, 0)
        return l
    end

    local widgetMakers = {}

    local rowRight = setmetatable({}, { __mode = "k" })
    local function rowRightGet(row) return rowRight[row] or 8 end

    local PRESET_COLORS = {
        Color3.fromRGB(235, 45, 75), Color3.fromRGB(255, 120, 60), Color3.fromRGB(255, 205, 90), Color3.fromRGB(120, 255, 160),
        Color3.fromRGB(80, 220, 130), Color3.fromRGB(110, 180, 255), Color3.fromRGB(150, 110, 255), Color3.fromRGB(255, 130, 200),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(150, 150, 162), Color3.fromRGB(60, 200, 220), Color3.fromRGB(255, 75, 85),
    }

    local function addColorPickerTo(row, obj, idx, data)
        data = data or {}
        local o = { Value = data.Default or Color3.new(1, 1, 1), _cbs = {}, Type = "ColorPicker" }
        local saved = savedOption(idx)
        if typeof(saved) == "Color3" then o.Value = saved end
        function o:OnChanged(fn) table.insert(self._cbs, fn) end
        function o:SetValueRGB(c)
            self.Value = c
            self._swatch.BackgroundColor3 = c
            fireCbs(self, c)
            saveAll()
        end
        function o:SetValue(c) self:SetValueRGB(c) end
        local right = rowRightGet(row)
        local sw = Instance.new("TextButton")
        sw.Size = UDim2.new(0, 22, 0, 22)
        sw.Position = UDim2.new(1, -(right + 22), 0.5, -11)
        sw.BackgroundColor3 = o.Value
        sw.Text = ""
        sw.BorderSizePixel = 0
        sw.AutoButtonColor = false
        sw.ZIndex = 7
        sw.Parent = row
        corner(sw, 6)
        stroke(sw, COLORS.strokeSoft, 1, 0.4)
        rowRight[row] = right + 28
        o._swatch = sw
        sw.Activated:Connect(function()
            local cols = 6
            local rowsN = math.ceil(#PRESET_COLORS / cols)
            local pop, closePop = openPopup(16 + rowsN * 28)
            for i, c in ipairs(PRESET_COLORS) do
                local cx = (i - 1) % cols
                local cy = math.floor((i - 1) / cols)
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(0, 24, 0, 24)
                b.Position = UDim2.new(0, 10 + cx * 32, 0, 8 + cy * 28)
                b.BackgroundColor3 = c
                b.Text = ""
                b.BorderSizePixel = 0
                b.ZIndex = 71
                b.Parent = pop
                corner(b, 6)
                b.Activated:Connect(function()
                    o:SetValueRGB(c)
                    closePop()
                end)
            end
        end)
        if idx then Library.Options[idx] = o end
        return o
    end

    local function addKeyPickerTo(row, parentToggle, idx, data)
        data = data or {}
        local o = { Value = data.Default or "None", Mode = data.Mode or "Toggle", _cbs = {}, _state = false, Type = "KeyPicker" }
        local saved = savedOption(idx)
        if type(saved) == "string" then o.Value = saved end
        function o:OnChanged(fn) table.insert(self._cbs, fn) end
        function o:GetState()
            if self.Mode == "Always" then return true end
            if self.Mode == "Hold" then
                if self.Value == "None" then return false end
                local ok, kc = pcall(function() return Enum.KeyCode[self.Value] end)
                return ok and kc and UIS:IsKeyDown(kc) or false
            end
            return self._state
        end
        function o:SetValue(t)
            if type(t) == "table" then
                self.Value = t[1] or "None"
                self.Mode = t[2] or self.Mode
            else
                self.Value = t
            end
            self._btn.Text = self.Value
            fireCbs(self, self.Value)
            saveAll()
        end
        local right = rowRightGet(row)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 46, 0, 22)
        btn.Position = UDim2.new(1, -(right + 46), 0.5, -11)
        btn.BackgroundColor3 = COLORS.row2
        btn.BackgroundTransparency = 0.3
        btn.Text = o.Value
        btn.TextColor3 = COLORS.white
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.ZIndex = 7
        btn.Parent = row
        corner(btn, 7)
        stroke(btn, COLORS.strokeSoft, 1, 0.55)
        rowRight[row] = right + 52
        o._btn = btn
        btn.Activated:Connect(function()
            if anyListening then return end
            if not UIS.KeyboardEnabled then
                Library:Notify({ Title = tr("Keybind"), Description = tr("Keybinds need a keyboard"), Time = 3 })
                return
            end
            anyListening = true
            btn.Text = "..."
            task.delay(6, function()
                if anyListening and btn.Text == "..." then
                    anyListening = false
                    btn.Text = o.Value
                end
            end)
            local conn
            conn = UIS.InputBegan:Connect(function(inp, gp)
                if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
                conn:Disconnect()
                anyListening = false
                if inp.KeyCode == Enum.KeyCode.Escape then
                    o:SetValue("None")
                else
                    o:SetValue(inp.KeyCode.Name)
                end
                if parentToggle and data.SyncToggleState then
                    parentToggle:SetValue(true)
                end
            end)
        end)
        UIS.InputBegan:Connect(function(inp, gp)
            if gp or anyListening then return end
            if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if o.Value == "None" then return end
            local ok, kc = pcall(function() return Enum.KeyCode[o.Value] end)
            if ok and kc and inp.KeyCode == kc then
                o._state = not o._state
                if parentToggle and data.SyncToggleState then
                    parentToggle:SetValue(o._state)
                end
                fireCbs(o, o._state)
            end
        end)
        if idx then Library.Options[idx] = o end
        return o
    end

    function widgetMakers.AddToggle(box, container, idx, data)
        data = data or {}
        local t = { Value = false, _cbs = {}, Type = "Toggle" }
        local saved = savedToggle(idx)
        if saved ~= nil then t.Value = saved elseif data.Default then t.Value = true end
        local disabled = data.Disabled == true
        local row = mkRow(container, 34)
        local lbl = rowLabel(row, tostring(data.Text or idx))
        if disabled then lbl.TextColor3 = COLORS.dim end
        if data.Risky then lbl.TextColor3 = COLORS.risky end
        local track = Instance.new("Frame")
        track.Size = UDim2.new(0, 56, 0, 26)
        track.Position = UDim2.new(1, -(rowRightGet(row) + 56), 0.5, -13)
        track.BackgroundColor3 = Color3.fromRGB(58, 58, 62)
        track.BackgroundTransparency = 0.05
        track.BorderSizePixel = 0
        track.ZIndex = 7
        track.Parent = row
        corner(track, 7)
        stroke(track, COLORS.strokeSoft, 1, 0.55)
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 20, 0, 20)
        knob.Position = UDim2.new(0, 3, 0.5, -10)
        knob.BackgroundColor3 = Color3.fromRGB(170, 170, 175)
        knob.BorderSizePixel = 0
        knob.ZIndex = 8
        knob.Parent = track
        corner(knob, 5)
        rowRight[row] = rowRightGet(row) + 62
        local rowStroke = row:FindFirstChildOfClass("UIStroke")
        local function vis()
            local on = t.Value == true
            TS:Create(knob, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = on and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10),
                BackgroundColor3 = on and Color3.fromRGB(245, 245, 245) or Color3.fromRGB(170, 170, 175),
            }):Play()
            track.BackgroundColor3 = on and themeColor() or Color3.fromRGB(58, 58, 62)
            row:SetAttribute("OptionActive", on)
            row.BackgroundColor3 = on and COLORS.row:Lerp(themeColor(), 0.18) or COLORS.row
            row.BackgroundTransparency = on and 0.08 or 0.22
            if rowStroke then
                rowStroke.Color = on and themeColor() or COLORS.stroke
                rowStroke.Transparency = on and 0.35 or 0.82
            end
        end
        onTheme(function() vis() end)
        function t:OnChanged(fn) table.insert(self._cbs, fn) end
        function t:SetValue(v, noSave)
            self.Value = v == true
            vis()
            fireCbs(self, self.Value)
            if not noSave then saveAll() end
        end
        function t:AddColorPicker(i2, d2) return addColorPickerTo(row, self, i2, d2) end
        function t:AddKeyPicker(i2, d2) return addKeyPickerTo(row, self, i2, d2) end
        if type(data.Callback) == "function" then t:OnChanged(data.Callback) end
        local clk = Instance.new("TextButton")
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.ZIndex = 6
        clk.Parent = row
        clk.Activated:Connect(function()
            if anyListening then return end
            if disabled then
                Library:Notify({ Title = tostring(data.Text or idx), Description = tostring(data.DisabledTooltip or "Disabled"), Time = 2 })
                return
            end
            t:SetValue(not t.Value)
        end)
        t._row = row
        Library.Toggles[idx] = t
        vis()
        if t.Value then task.defer(function() fireCbs(t, true) end) end
        return t
    end

    function widgetMakers.AddSlider(box, container, idx, data)
        data = data or {}
        local minV = data.Min or 0
        local maxV = data.Max or 100
        local rounding = data.Rounding or 0
        local step = 10 ^ -rounding
        if step > 1 then step = 1 end
        local suffix = data.Suffix or ""
        local o = { Value = data.Default or minV, _cbs = {}, Type = "Slider" }
        local saved = savedOption(idx)
        if type(saved) == "number" then o.Value = saved end
        local row = mkRow(container, 34)
        rowLabel(row, tostring(data.Text or idx))
        local function fmt(v)
            if rounding > 0 then return string.format("%." .. rounding .. "f", v) .. suffix end
            return tostring(math.floor(v + 0.5)) .. suffix
        end
        local valLbl = mkText(row, fmt(o.Value), 11, COLORS.white, true)
        valLbl.TextXAlignment = Enum.TextXAlignment.Center
        valLbl.Position = UDim2.new(1, -78, 0.5, -11)
        valLbl.Size = UDim2.new(0, 46, 0, 22)
        local function mkStepBtn(txt, xOff)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0, 24, 0, 22)
            b.Position = UDim2.new(1, -xOff, 0.5, -11)
            b.BackgroundColor3 = COLORS.row2
            b.Text = txt
            b.TextColor3 = COLORS.white
            b.Font = Enum.Font.GothamBold
            b.TextSize = 14
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.ZIndex = 7
            b.Parent = row
            corner(b, 7)
            stroke(b, COLORS.strokeSoft, 1, 0.75)
            return b
        end
        local minus = mkStepBtn("-", 106)
        local plus = mkStepBtn("+", 30)
        function o:OnChanged(fn) table.insert(self._cbs, fn) end
        function o:SetValue(v, noSave)
            v = tonumber(v) or minV
            v = math.clamp(v, minV, maxV)
            if rounding > 0 then
                v = math.floor(v / step + 0.5) * step
                v = tonumber(string.format("%." .. rounding .. "f", v))
            else
                v = math.floor(v + 0.5)
            end
            self.Value = v
            valLbl.Text = fmt(v)
            fireCbs(self, v)
            if not noSave then saveAll() end
        end
        local function holdBtn(btn, dir)
            btn.InputBegan:Connect(function(inp)
                if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
                o:SetValue(o.Value + dir * step)
                local stopped = false
                inp.Changed:Connect(function()
                    if inp.UserInputState == Enum.UserInputState.End then stopped = true end
                end)
                task.spawn(function()
                    task.wait(0.45)
                    while not stopped do
                        o:SetValue(o.Value + dir * step)
                        task.wait(0.06)
                    end
                end)
            end)
        end
        holdBtn(minus, -1)
        holdBtn(plus, 1)
        Library.Options[idx] = o
        valLbl.Text = fmt(o.Value)
        return o
    end

    function widgetMakers.AddDropdown(box, container, idx, data)
        data = data or {}
        local multi = data.Multi == true
        local allowNull = data.AllowNull == true
        local values = data.Values or {}
        local o = { Value = multi and {} or (data.Default ~= nil and values[data.Default] or data.Default or nil), _cbs = {}, Type = "Dropdown" }
        if multi and type(data.Default) == "table" then
            for _, v in ipairs(data.Default) do o.Value[v] = true end
        end
        local saved = savedOption(idx)
        if saved ~= nil then o.Value = saved end
        local row = mkRow(container, 34)
        rowLabel(row, tostring(data.Text or idx))
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 100, 0, 24)
        btn.Position = UDim2.new(1, -108, 0.5, -12)
        btn.BackgroundColor3 = COLORS.row2
        btn.BackgroundTransparency = 0.3
        btn.TextColor3 = COLORS.white
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.ZIndex = 7
        btn.Parent = row
        corner(btn, 7)
        stroke(btn, COLORS.strokeSoft, 1, 0.55)
        local function label()
            if multi then
                local n = 0
                for _ in pairs(o.Value) do n = n + 1 end
                return tostring(n) .. " sel"
            end
            return o.Value ~= nil and tostring(o.Value) or "-"
        end
        local function refresh()
            btn.Text = label() .. "  v"
        end
        function o:OnChanged(fn) table.insert(self._cbs, fn) end
        function o:SetValue(v, noSave)
            if multi and type(v) == "table" and v[1] ~= nil then
                local d = {}
                for _, x in ipairs(v) do d[x] = true end
                v = d
            end
            self.Value = v
            refresh()
            fireCbs(self, v)
            if not noSave then saveAll() end
        end
        function o:SetValues(vals) values = vals or {} end
        btn.Activated:Connect(function()
            local showN = math.min(#values, 8)
            local pop, closePop = openPopup(12 + showN * 28)
            local sf = Instance.new("ScrollingFrame")
            sf.Size = UDim2.new(1, -12, 1, -12)
            sf.Position = UDim2.new(0, 6, 0, 6)
            sf.BackgroundTransparency = 1
            sf.BorderSizePixel = 0
            sf.ScrollBarThickness = 2
            sf.ScrollBarImageColor3 = COLORS.accent
            onTheme(function(c) sf.ScrollBarImageColor3 = c end)
            sf.CanvasSize = UDim2.new(0, 0, 0, #values * 28)
            sf.ZIndex = 71
            sf.Parent = pop
            local ll = Instance.new("UIListLayout")
            ll.Padding = UDim.new(0, 4)
            ll.Parent = sf
            for _, v in ipairs(values) do
                local sel = multi and o.Value[v] == true or (not multi and o.Value == v)
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1, -4, 0, 24)
                b.BackgroundColor3 = sel and COLORS.accent or COLORS.row2
                b.BackgroundTransparency = sel and 0.2 or 0.4
                b.Text = tostring(v)
                b.TextColor3 = COLORS.white
                b.Font = Enum.Font.GothamBold
                b.TextSize = 11
                b.BorderSizePixel = 0
                b.ZIndex = 72
                b.Parent = sf
                corner(b, 6)
                b.Activated:Connect(function()
                    if multi then
                        if o.Value[v] then
                            o.Value[v] = nil
                        else
                            o.Value[v] = true
                        end
                        b.BackgroundColor3 = o.Value[v] and COLORS.accent or COLORS.row2
                        b.BackgroundTransparency = o.Value[v] and 0.2 or 0.4
                        refresh()
                        fireCbs(o, o.Value)
                        saveAll()
                    else
                        if o.Value == v and allowNull then
                            o:SetValue(nil)
                        else
                            o:SetValue(v)
                        end
                        closePop()
                    end
                end)
            end
        end)
        refresh()
        Library.Options[idx] = o
        return o
    end

    function widgetMakers.AddButton(box, container, a, b)
        local data = type(a) == "table" and a or { Text = a, Func = b }
        local row = mkRow(container, 34)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 1, -4)
        btn.Position = UDim2.new(0, 2, 0, 2)
        btn.BackgroundColor3 = data.Risky and COLORS.accent or COLORS.row2
        btn.BackgroundTransparency = data.Risky and 0.5 or 0.3
        btn.Text = tr(tostring(data.Text or "Button"))
        btn.TextColor3 = data.Risky and COLORS.risky or COLORS.white
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.ZIndex = 7
        btn.Parent = row
        corner(btn, 8)
        local lastClick = 0
        btn.Activated:Connect(function()
            if data.Disabled then
                Library:Notify({ Title = tostring(data.Text), Description = tostring(data.DisabledTooltip or "Disabled"), Time = 2 })
                return
            end
            if data.DoubleClick then
                local now = tick()
                if now - lastClick > 0.5 then
                    lastClick = now
                    btn.Text = tr(tostring(data.Text)) .. "  ?"
                    task.delay(0.6, function() btn.Text = tr(tostring(data.Text)) end)
                    return
                end
            end
            if data.Func then task.spawn(function() pcall(data.Func) end) end
        end)
        return btn
    end

    function widgetMakers.AddLabel(box, container, txt, wrap)
        local h = wrap and 30 or 18
        local l = mkText(container._frame, tostring(txt), 11, COLORS.dim, false)
        l.Size = UDim2.new(1, -8, 0, h)
        l.TextWrapped = wrap == true
        l.ZIndex = 4
        containerAdd(container, h)
        return l
    end

    function widgetMakers.AddDivider(box, container)
        local d = Instance.new("Frame")
        d.Size = UDim2.new(1, -16, 0, 1)
        d.BackgroundColor3 = COLORS.stroke
        d.BackgroundTransparency = 0.5
        d.BorderSizePixel = 0
        d.ZIndex = 4
        d.Parent = container._frame
        containerAdd(container, 5)
        return d
    end

    function widgetMakers.AddInput(box, container, idx, data)
        data = data or {}
        local o = { Value = data.Default or "", _cbs = {}, Type = "Input" }
        local saved = savedOption(idx)
        if type(saved) == "string" then o.Value = saved end
        local row = mkRow(container, 34)
        rowLabel(row, tostring(data.Text or idx))
        local box2 = Instance.new("TextBox")
        box2.Size = UDim2.new(0, 110, 0, 24)
        box2.Position = UDim2.new(1, -118, 0.5, -12)
        box2.BackgroundColor3 = COLORS.row2
        box2.BackgroundTransparency = 0.3
        box2.TextColor3 = COLORS.white
        box2.Font = Enum.Font.GothamBold
        box2.TextSize = 11
        box2.Text = tostring(o.Value)
        box2.PlaceholderText = tostring(data.Placeholder or "")
        box2.ClearTextOnFocus = false
        box2.BorderSizePixel = 0
        box2.ZIndex = 7
        box2.Parent = row
        corner(box2, 7)
        stroke(box2, COLORS.strokeSoft, 1, 0.55)
        function o:OnChanged(fn) table.insert(self._cbs, fn) end
        function o:SetValue(v)
            self.Value = tostring(v)
            box2.Text = self.Value
            fireCbs(self, self.Value)
            saveAll()
        end
        local function commit()
            local txt = box2.Text
            if data.Numeric then
                txt = tostring(tonumber(txt) or o.Value)
                box2.Text = txt
            end
            o.Value = txt
            fireCbs(o, txt)
            if data.Finished and data.Func then task.spawn(function() pcall(data.Func, txt) end) end
            saveAll()
        end
        box2.FocusLost:Connect(function() commit() end)
        Library.Options[idx] = o
        return o
    end

    local function newSection(container, name)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, 0, 0, 22)
        f.BackgroundTransparency = 1
        f.ZIndex = 4
        f.Parent = container._frame
        local l = mkText(f, tr(tostring(name)):upper(), 11, COLORS.accentStrong, true)
        l.Font = Enum.Font.GothamBlack
        l.Position = UDim2.new(0, 4, 0, 0)
        l.Size = UDim2.new(1, -4, 1, 0)
        l.ZIndex = 4
        containerAdd(container, 22)
        return f
    end

    local function wrapContainer(frame, sub, tabbox)
        local c = { _frame = frame, _h = 0, _sub = sub, _tabbox = tabbox }
        for name, fn in pairs(widgetMakers) do
            c[name] = function(self, a, b2, c2)
                local ok, res = pcall(fn, self, c, a, b2, c2)
                if not ok then
                    warn("[BHUB] widget " .. tostring(name) .. " failed: " .. tostring(res))
                    if not Library._errNotified then
                        Library._errNotified = true
                        Library:Notify({ Title = "BHUB UI", Description = "Widget error: " .. tostring(name), Time = 6 })
                    end
                end
                return res
            end
        end
        return c
    end

    local function newGroupbox(pageContainer, name)
        newSection(pageContainer, name)
        return pageContainer
    end

    local function newTabbox(pageContainer, name)
        newSection(pageContainer, name)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 40)
        frame.BackgroundColor3 = COLORS.panel
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.ZIndex = 4
        frame.ClipsDescendants = true
        frame.Parent = pageContainer._frame
        corner(frame, 10)
        stroke(frame, COLORS.stroke, 1, 0.7)
        containerAdd(pageContainer, 40)
        local btnRow = Instance.new("Frame")
        btnRow.Size = UDim2.new(1, -8, 0, 26)
        btnRow.Position = UDim2.new(0, 4, 0, 4)
        btnRow.BackgroundTransparency = 1
        btnRow.ZIndex = 6
        btnRow.Parent = frame
        local btnLayout = Instance.new("UIListLayout")
        btnLayout.FillDirection = Enum.FillDirection.Horizontal
        btnLayout.Padding = UDim.new(0, 4)
        btnLayout.Parent = btnRow
        local tabbox = { _frame = frame, _subs = {}, _active = nil }
        function tabbox:AddTab(tabName)
            local sub = Instance.new("Frame")
            sub.Size = UDim2.new(1, -8, 0, 0)
            sub.Position = UDim2.new(0, 4, 0, 34)
            sub.BackgroundTransparency = 1
            sub.Visible = false
            sub.ZIndex = 5
            sub.Parent = frame
            local subLayout = Instance.new("UIListLayout")
            subLayout.SortOrder = Enum.SortOrder.LayoutOrder
            subLayout.Padding = UDim.new(0, 4)
            subLayout.Parent = sub
            local container = wrapContainer(sub, true, tabbox)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 70, 0, 24)
            btn.BackgroundColor3 = COLORS.row
            btn.BackgroundTransparency = 0.3
            btn.Text = tostring(tabName)
            btn.TextColor3 = COLORS.dim
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 10
            btn.BorderSizePixel = 0
            btn.AutoButtonColor = false
            btn.ZIndex = 7
            btn.Parent = btnRow
            corner(btn, 7)
            btn.Activated:Connect(function()
                for _, s2 in ipairs(tabbox._subs) do
                    s2._container._frame.Visible = false
                    s2._btn.TextColor3 = COLORS.dim
                    s2._btn.BackgroundColor3 = COLORS.row
                end
                sub.Visible = true
                btn.TextColor3 = COLORS.white
                btn.BackgroundColor3 = COLORS.accent
                tabbox._active = container
                frame.Size = UDim2.new(1, 0, 0, 34 + container._h + 6)
            end)
            local entry = { _container = container, _btn = btn }
            table.insert(tabbox._subs, entry)
            if #tabbox._subs == 1 then
                sub.Visible = true
                btn.TextColor3 = COLORS.white
                btn.BackgroundColor3 = COLORS.accent
                tabbox._active = container
            end
            return container
        end
        return tabbox
    end

    local TAB_MERGE = {
        ["General"] = "Main",
        ["Archives"] = "Floors",
        ["Stairwell"] = "Floors",
        ["New - Halloween"] = "Floors",
    }

    function Library:CreateWindow(info)
        info = info or {}
        local Window = {}
        function Window:AddTab(tabName, _icon)
            local dispName = TAB_MERGE[tostring(tabName)] or tostring(tabName)
            for _, existing in ipairs(allTabs) do
                if existing._name == dispName then
                    return existing
                end
            end
            local page = Instance.new("ScrollingFrame")
            page.Size = UDim2.new(1, 0, 1, 0)
            page.BackgroundTransparency = 1
            page.BorderSizePixel = 0
            page.ScrollBarThickness = 3
            page.ScrollBarImageColor3 = COLORS.accent
            onTheme(function(c) page.ScrollBarImageColor3 = c end)
            page.CanvasSize = UDim2.new(0, 0, 0, 0)
            page.Visible = false
            page.ZIndex = 3
            page.Parent = pagesHolder

            local function mkCol(xScale, xOff)
                local col = Instance.new("Frame")
                col.Size = UDim2.new(0.5, -7, 1, 0)
                col.Position = UDim2.new(xScale, xOff, 0, 2)
                col.BackgroundTransparency = 1
                col.ZIndex = 3
                col.Parent = page
                local ll = Instance.new("UIListLayout")
                ll.SortOrder = Enum.SortOrder.LayoutOrder
                ll.Padding = UDim.new(0, 4)
                ll.Parent = col
                return col
            end
            local colL = mkCol(0, 2)
            local colR = mkCol(0.5, 5)
            local contL = wrapContainer(colL, false, nil)
            local contR = wrapContainer(colR, false, nil)
            contL._page = page
            contR._page = page
            contL._sib = contR
            contR._sib = contL
            local container = contL

            local tb = Instance.new("TextButton")
            tb.Name = dispName
            tb.Size = UDim2.new(1, 0, 0, 38)
            tb.BackgroundColor3 = COLORS.row
            tb.BackgroundTransparency = 0.28
            tb.TextColor3 = COLORS.dim
            tb.Text = tr(dispName)
            tb.Font = Enum.Font.GothamBold
            tb.TextSize = 9
            tb.TextWrapped = true
            tb.BorderSizePixel = 0
            tb.AutoButtonColor = false
            tb.ZIndex = 6
            tb.Parent = tabCol
            corner(tb, 8)
            local tbStroke = stroke(tb, COLORS.strokeSoft, 1, 0.65)

            local tab = { _page = page, _container = container, _btn = tb, _name = dispName, _contL = contL, _contR = contR }
            function tab:AddLeftGroupbox(name) return newGroupbox(contL, name) end
            function tab:AddRightGroupbox(name) return newGroupbox(contR, name) end
            function tab:AddGroupbox(name)
                if contL._h <= contR._h then return newGroupbox(contL, name) end
                return newGroupbox(contR, name)
            end
            function tab:AddLeftTabbox(name) return newTabbox(contL, name) end
            function tab:AddRightTabbox(name) return newTabbox(contR, name) end
            local warnRef = nil
            function tab:UpdateWarningBox(opts)
                opts = opts or {}
                if opts.Visible == false then
                    if warnRef then warnRef.f:Destroy() warnRef = nil end
                    return
                end
                if not warnRef then
                    local wf = Instance.new("Frame")
                    wf.Size = UDim2.new(1, 0, 0, 38)
                    wf.BackgroundColor3 = COLORS.row
                    wf.BackgroundTransparency = 0.2
                    wf.BorderSizePixel = 0
                    wf.ZIndex = 4
                    wf.LayoutOrder = -1000
                    wf.Parent = colL
                    corner(wf, 8)
                    stroke(wf, COLORS.risky, 1.2, 0.4)
                    local wt = mkText(wf, "", 11, COLORS.risky, true)
                    wt.Position = UDim2.new(0, 8, 0, 4)
                    wt.Size = UDim2.new(1, -16, 0, 13)
                    local wx = mkText(wf, "", 10, COLORS.dim, false)
                    wx.TextWrapped = true
                    wx.Position = UDim2.new(0, 8, 0, 19)
                    wx.Size = UDim2.new(1, -16, 0, 15)
                    warnRef = { f = wf, t = wt, x = wx }
                end
                warnRef.t.Text = tostring(opts.Title or "")
                warnRef.x.Text = tostring(opts.Text or "")
                warnRef.f.Visible = true
            end
            tb.Activated:Connect(function()
                if popupClose then pcall(popupClose) popupClose = nil end
                for _, t2 in ipairs(allTabs) do
                    t2._page.Visible = false
                    t2._btn.TextColor3 = COLORS.dim
                    t2._btn.BackgroundColor3 = COLORS.row
                    t2._btn.BackgroundTransparency = 0.28
                end
                page.Visible = true
                tb.TextColor3 = COLORS.white
                tb.BackgroundColor3 = COLORS.row2
                tb.BackgroundTransparency = 0.05
                tbStroke.Color = COLORS.accent
                tbStroke.Transparency = 0.25
                for _, t2 in ipairs(allTabs) do
                    if t2 ~= tab then
                        local st = t2._btn:FindFirstChildOfClass("UIStroke")
                        if st then st.Color = COLORS.strokeSoft st.Transparency = 0.65 end
                    end
                end
                activeTab = tab
            end)
            table.insert(allTabs, tab)
            if #allTabs == 1 then
                page.Visible = true
                tb.TextColor3 = COLORS.white
                tb.BackgroundColor3 = COLORS.row2
                tb.BackgroundTransparency = 0.05
                tbStroke.Color = COLORS.accent
                tbStroke.Transparency = 0.25
                activeTab = tab
            end
            return tab
        end
        function Window:SetActiveTab(tabName)
            for _, t2 in ipairs(allTabs) do
                if t2._name == tostring(tabName) or t2._btn.Text == tostring(tabName) then
                    t2._btn.Activated:Fire()
                end
            end
        end
        return Window
    end

    local unloadCbs = {}
    function Library:OnUnload(cb)
        if type(cb) == "function" then table.insert(unloadCbs, cb) end
    end

    function Library:Unload()
        if self.Unloaded then return end
        self.Unloaded = true
        for _, cb in ipairs(unloadCbs) do task.spawn(function() pcall(cb) end) end
        saveAll()
        pcall(removeHeadTag)
        pcall(function() GUI:Destroy() end)
    end

    local SaveManager = {}
    function SaveManager:SetLibrary(_) end
    function SaveManager:SetFolder(_) end
    function SaveManager:SetSubFolder(_) end
    function SaveManager:IgnoreThemeSettings() end
    function SaveManager:SetIgnoreIndexes(_) end
    function SaveManager:BuildConfigSection(_) end
    function SaveManager:LoadAutoloadConfig() end
    function SaveManager:SaveConfig(_) saveAll() end

    local ThemeManager = {}
    function ThemeManager:SetLibrary(_) end
    function ThemeManager:SetFolder(_) end
    function ThemeManager:ApplyToTab(_) end
    function ThemeManager:ApplyTheme(_) return true end

    local Interface = {
        Library = Library,
        SaveManager = SaveManager,
        ThemeManager = ThemeManager,
    }

    function Interface.ApplyInfoTab(Window)
        local tab = Window:AddTab("Info", "info")
        local left = tab:AddLeftGroupbox("BHUB DOORS")
        widgetMakers.AddLabel(left, left, "BALTIKA HUB — DOORS", false)
        widgetMakers.AddLabel(left, left, "Made by BALTIKA HUB", false)
        widgetMakers.AddLabel(left, left, "Discord: " .. DISCORD_SHORT, false)
        local right = tab:AddRightGroupbox("Discord")
        widgetMakers.AddButton(right, right, { Text = "Copy Discord", Func = function()
            pcall(function() if type(setclipboard) == "function" then setclipboard(DISCORD_LINK) end end)
            Library:Notify({ Title = "BHUB", Description = DISCORD_LINK, Time = 2 })
        end })
    end

    function Interface.ApplySettingsTab(Window)
        local tab = Window:AddTab("Settings", "settings")
        local menu = tab:AddLeftGroupbox("Menu")
        local row = mkRow(menu, 34)
        rowLabel(row, "Menu Keybind")
        addKeyPickerTo(row, nil, "MenuKeybind", { Default = "RightShift", Mode = "Toggle" })
        widgetMakers.AddToggle(menu, menu, "UI_LockGUI", { Text = "Lock GUI", Default = UISet.locked, Callback = function(v)
            UISet.locked = v == true
            saveAll()
        end })
        widgetMakers.AddToggle(menu, menu, "UI_NoIntro", { Text = "No Intro", Default = UISet.noIntro, Callback = function(v)
            UISet.noIntro = v == true
            saveAll()
        end })
        widgetMakers.AddToggle(menu, menu, "UI_HeadTag", { Text = "Overhead Text", Default = UISet.headTag, Callback = function(v)
            UISet.headTag = v == true
            if UISet.headTag then task.spawn(buildHeadTag) else removeHeadTag() end
            saveAll()
        end })

        local app = tab:AddRightGroupbox("Appearance")
        widgetMakers.AddDropdown(app, app, "UI_Language", {
            Text = "Language", Values = { "English", "Русский" },
            Default = (UISet.lang == "RU") and "Русский" or "English",
        })
        Library.Options.UI_Language:OnChanged(function(v)
            UISet.lang = (v == "Русский") and "RU" or "EN"
            applyLang()
            saveAll()
            Library:Notify({ Title = "BHUB", Description = tr("Full translation after script restart"), Time = 4 })
        end)
        do
            local trow = mkRow(app, 34)
            rowLabel(trow, "Accent Color")
            local picker = Instance.new("Frame")
            picker.Size = UDim2.new(0, 130, 0, 22)
            picker.Position = UDim2.new(1, -138, 0.5, -11)
            picker.BackgroundTransparency = 1
            picker.ZIndex = 6
            picker.Parent = trow
            local lay = Instance.new("UIListLayout")
            lay.FillDirection = Enum.FillDirection.Horizontal
            lay.Padding = UDim.new(0, 5)
            lay.VerticalAlignment = Enum.VerticalAlignment.Center
            lay.HorizontalAlignment = Enum.HorizontalAlignment.Right
            lay.SortOrder = Enum.SortOrder.LayoutOrder
            lay.Parent = picker
            local dots = {}
            local function refreshDots()
                for name, d in pairs(dots) do
                    local sel = (name == UISet.themeName)
                    d.btn.Size = sel and UDim2.new(0, 18, 0, 18) or UDim2.new(0, 16, 0, 16)
                    d.st.Transparency = sel and 0 or 0.6
                    d.st.Thickness = sel and 2 or 1.2
                end
            end
            for idx, preset in ipairs(THEMES) do
                local b = Instance.new("TextButton")
                b.LayoutOrder = idx
                b.Size = UDim2.new(0, 16, 0, 16)
                b.BackgroundColor3 = preset.color
                b.BorderSizePixel = 0
                b.Text = ""
                b.AutoButtonColor = false
                b.ZIndex = 7
                b.Parent = picker
                corner(b, 1).CornerRadius = UDim.new(1, 0)
                local st = stroke(b, Color3.fromRGB(255, 255, 255), 1.2, 0.6)
                dots[preset.name] = { btn = b, st = st }
                b.Activated:Connect(function()
                    UISet.themeName = preset.name
                    applyTheme()
                    refreshDots()
                    saveAll()
                end)
            end
            refreshDots()
        end
        local bgSlider = widgetMakers.AddSlider(app, app, "UI_BgIntensity", { Text = "BG Intensity", Min = 0, Max = 100, Default = math.floor(UISet.bgI * 100 + 0.5), Suffix = "%" })
        bgSlider:OnChanged(function(v)
            UISet.bgI = math.clamp((tonumber(v) or 0) / 100, 0, 1)
            applyBg()
        end)
        local scaleSlider = widgetMakers.AddSlider(app, app, "UI_GuiScale", { Text = "GUI Size", Min = 60, Max = 160, Default = math.floor(UISet.guiScale * 100 + 0.5), Suffix = "%" })
        scaleSlider:OnChanged(function(v)
            UISet.guiScale = math.clamp((tonumber(v) or 100) / 100, 0.6, 1.6)
            updateScale()
        end)

        local disc = tab:AddLeftGroupbox("Discord")
        widgetMakers.AddButton(disc, disc, { Text = "Copy Discord  " .. DISCORD_SHORT, Func = function()
            pcall(function() if type(setclipboard) == "function" then setclipboard(DISCORD_LINK) end end)
            Library:Notify({ Title = "BHUB", Description = DISCORD_LINK, Time = 2 })
        end })

        local cfg = tab:AddRightGroupbox("Config")
        widgetMakers.AddButton(cfg, cfg, { Text = "Save Config", Func = function()
            saveAll()
            Library:Notify({ Title = "BHUB", Description = "Config saved", Time = 2 })
        end })
        widgetMakers.AddButton(cfg, cfg, { Text = "Unload", Risky = true, DoubleClick = true, Func = function()
            Library:Unload()
        end })
    end

    return Interface
end

return BHubInterface

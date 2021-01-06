////////////////////////////////////////////////////////////////////////////////
// Модуль для работы с чат-ботом (сервер).
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Отправляет сообщение от чат-бота пользователю.
//
// Параметры:
//  Кому         - СправочникСсылка.Пользователи - Кому следует отправить сообщение.
//  Текст        - Строка                        - Текст сообщения.
//  Вложения     - Массив из Структура           - Вложения сообщения. См. РаботаСЧатБотом.ВложениеЧатБота().
//  Действия     - СписокЗначение, Структура     - Действия сообщения
//  ЗаписьБеседы - Структура                     - см. РаботаСЧатБотомКлиентСервер.НоваяЗаписьБеседы
// 
// Возвращаемое значение:
//  Структура - Результат отправки сообщения от чат-бота.
//   * Отправлено  - Булево - Сообщение было отправлено.
//   * ТекстОшибки - Строка - Текст ошибки, почему сообщение не было отправлено.
//
Функция ОтправитьСообщение(
	Кому, Текст = "", Вложения = Неопределено, Действия = Неопределено, ЗаписьБеседы = Неопределено) Экспорт
	
	Если Не ЧатБотИспользуется() Тогда
	
		РезультатОтправки = Новый Структура();
		РезультатОтправки.Вставить("Отправлено", Ложь);
		РезультатОтправки.Вставить("ТекстОшибки", НСтр("ru = 'Чат-бот неактивен.'"));
		
		Возврат РезультатОтправки;
		
	КонецЕсли; 
	
	ЧатБот = РаботаСЧатБотомПовтИсп.ЧатБот();
	СтруктураВложений = ПодготовитьВложенияКОтправкеЧерезСВ(Вложения);
	Если СтруктураВложений = Неопределено Тогда 
		ВложенияСВ = Неопределено;
	Иначе 
		Если ЗначениеЗаполнено(СтруктураВложений.ТекстВложений) Тогда 
			Текст = Текст + Символы.ПС + СтруктураВложений.ТекстВложений;
		КонецЕсли;
		ВложенияСВ = СтруктураВложений.ВложенияСВ;
	КонецЕсли;
	РезультатОтправкиСВ = ОбсужденияДокументооборот.ОтправитьЛичноеСообщение(
		ЧатБот, Кому, Текст, ВложенияСВ, Действия);
		
	Если Не ЗначениеЗаполнено(ЗаписьБеседы) Тогда

		ЗаписьБеседы = РаботаСЧатБотомКлиентСервер.НоваяЗаписьБеседы();

	КонецЕсли;
	
	Если РезультатОтправкиСВ.Отправлено Тогда
	
		ЗаписьБеседы.СообщениеБота = Текст;
	
	Иначе
	
		ЗаписьБеседы.СообщениеБота = РезультатОтправкиСВ.ТекстОшибки;
	
	КонецЕсли;
	
	РегистрыСведений.ИсторияБеседСЧатБотом.ОбновитьИсториюБеседы(ЗаписьБеседы);
	
	Возврат РезультатОтправкиСВ;
	
КонецФункции

// Отправляет сообщение от пользователя в диалог с чат-ботом
//
//Параметры:
//	Текст - Строка - Текст отправляемого сообщения
//
Функция ОтправитьСообщениеОтИмениПользователя(Текст) Экспорт

	ОтКого = ПользователиКлиентСервер.ТекущийПользователь();
	Кому = РаботаСЧатБотомПовтИсп.ЧатБот();
	РезультатОтправкиСВ = ОбсужденияДокументооборот.ОтправитьЛичноеСообщение(ОтКого, Кому, Текст);
	ЗаписьБеседы = РаботаСЧатБотомКлиентСервер.НоваяЗаписьБеседы();
	
	ЗаписьБеседы.СообщениеПользователя = Текст;
	ЗаписьБеседы.Пользователь = ОтКого;
	
	РегистрыСведений.ИсторияБеседСЧатБотом.ОбновитьИсториюБеседы(ЗаписьБеседы);
	
	Обсуждение = Новый Структура("Идентификатор", ОбсуждениеТекущегоПользователяСБотом().Идентификатор);
	Возврат Обсуждение;

КонецФункции

// Формирует пустую структуру вложения, которое умеет отправлять чат-бот.
// Совместим с типом ОбсужденияДокументооборот.ВложениеСВ().
// 
// Возвращаемое значение:
//  Структура - Вложение, которое умеет отправлять чат-бот.
//   * ИмяФайла    - Строка         - Наименование вложения.
//   * ДанныеФайла - ДвоичныеДанные - Двоичные данные, из которых будет создано вложение..
//
Функция ВложениеЧатБота(ИмяФайла, ДанныеФайла) Экспорт
	
	Возврат ОбсужденияДокументооборот.ВложениеСВ(ИмяФайла, ДанныеФайла);
	
КонецФункции

// Пишет приветственное сообщение, взятое из Константы.ПервоеСообщениеЧатБот
//  и показывает состояния доступные из начала.
//
Процедура НаписатьПервоеСообщение() Экспорт
	
	СостоянияГиперссылками = ПодчиненныеСостояния(ПредопределенноеЗначение("Справочник.СостоянияЧатБота.ПустаяСсылка"));
	Приветствие = ПервоеСообщениеЧатБота();
	
	// Если не задана константа, то не пишем пользовалю, а запускаемся в фоне.
	Если ЗначениеЗаполнено(Приветствие) И СостоянияГиперссылками.Количество() > 0 Тогда 
		Приветствие = Приветствие + Символы.ПС + НСтр("ru = 'Я умею'") + " ";
		ОтправитьСообщение(
			ПользователиКлиентСервер.ТекущийПользователь(),
			Приветствие,,
			СостоянияГиперссылками);
	КонецЕсли;
	
КонецПроцедуры

// Пишет пользователю одно из высказываний записанных в текущем состоянии.
//
// Параметры: 
//  ТекущееСостояние - СправочникСсылка.СостоянияЧатБота - Текущее состояние чат-бота.
//  ЗаписьБеседы - Структура - см. РаботаСЧатБотомКлиентСервер.НоваяЗаписьБеседы.
//
Процедура НаписатьПользователю(ТекущееСостояние, ЗаписьБеседы) Экспорт
	
	ТаблицаСостояний = СостоянияЧатБота(); 
	ОтборПоСсылке = Новый Структура("Ссылка", ТекущееСостояние);
	Состояние = ТаблицаСостояний.НайтиСтроки(ОтборПоСсылке);
	
	Если Состояние.Количество() = 0 Тогда 
		
		Возврат;
		
	КонецЕсли;
	
	ЧтоСказать = СтрРазделить(Состояние[0].Высказывание, "#", Ложь);
	
	Если ЧтоСказать.Количество() Тогда
		
		ГенераторСлучайныхЧисел = Новый ГенераторСлучайныхЧисел();
		СлучайноеЧисло = ГенераторСлучайныхЧисел.СлучайноеЧисло(0, ЧтоСказать.Количество() - 1);
		
		ОтправитьСообщение(
			ПользователиКлиентСервер.ТекущийПользователь(),
			ЧтоСказать[СлучайноеЧисло], Состояние[0].Вложения,, 
			ЗаписьБеседы);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает подчиненные состояния
//
// Параметры:
//  ТекущееСостояние - СправочникСсылка.СостоянияЧатБота - Текущее состояние чат-бота.
//
// Возвращаемое значение:
//	СписокЗначений - см. СостоянияДляПоказа
//
Функция ПодчиненныеСостояния(ТекущееСостояние) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СостоянияЧатБота.Действие КАК Действие,
		|	СостоянияЧатБота.ТипСостояния КАК ТипСостояния,
		|	СостоянияЧатБота.Ссылка КАК Ссылка,
		|	СостоянияЧатБота.Наименование КАК Наименование
		|ИЗ
		|	Справочник.СостоянияЧатБота КАК СостоянияЧатБота
		|ГДЕ
		|	СостоянияЧатБота.Родитель = &ТекущееСостояние
		|	И СостоянияЧатБота.Предопределенный = ЛОЖЬ
		|	И СостоянияЧатБота.ПометкаУдаления = ЛОЖЬ";
	
	Если Не ЭтоАдминистраторЧатБота() Тогда
	
		Запрос.Текст = Запрос.Текст + Символы.ПС + "И СостоянияЧатБота.Используется = ИСТИНА"; 
	
	КонецЕсли;
	
	Запрос.Параметры.Вставить("ТекущееСостояние", ТекущееСостояние);
	Запрос.Параметры.Вставить(
		"ТекущийПользователь", ПользователиКлиентСервер.ТекущийПользователь());
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Возврат СостоянияДляПоказа(Результат);
	
КонецФункции

// Возвращает состояние в которое следует перейти из текущего.
//
// Параметры: 
//  ТекущееСостояние - СправочникССылка.СостоянияЧатБота - ТекущееСостояние чат-бота
//  Сообщение - Строка - Текст сообщения отправленного пользователем
//  СостоянияДляУточнения - Массив из СправочникССылка.СостоянияЧатБота - массив состояний, которые
//    после прошлого сообщения пользователя оказались равновероятны для перехода
//  ЗаписьБеседы - Структура - см. РаботаСЧатБотомКлиентСервер.НоваяЗаписьБеседы
//
// ВозвращамоеЗначение:
//  Структура:
//    * Ссылка - СправочникСсылка.СостоянияЧатБота - состояние в которое следует перейти
//    * Предопределенный - Булево - Если Истина, то обрабатываем предопределенное состояние
//    * Действие - Срока - Строка с выполняемым кодом состояния, в которое переходим.
//
Функция СледующееСостояние(Знач ТекущееСостояние, Сообщение, СостоянияДляУточнения, ЗаписьБеседы) Экспорт
	
	ВозвращаемоеСостояние = Новый Структура();
	ВозвращаемоеСостояние.Вставить("Ссылка");
	ВозвращаемоеСостояние.Вставить("Предопределенный");
	ВозвращаемоеСостояние.Вставить("Действие");
	
	ЗаписьБеседы.СообщениеПользователя = Сообщение;
	ЗаписьБеседы.СостояниеИз = ТекущееСостояние;
	
	ПерейтиНаСледующееСостояние(ТекущееСостояние, Сообщение, СостоянияДляУточнения, ЗаписьБеседы);
	
	ЗаполнитьЗначенияСвойств(ВозвращаемоеСостояние, ТекущееСостояние); 
	ЗаписьБеседы.СостояниеВ = ТекущееСостояние;
	
	Если ВозвращаемоеСостояние.Предопределенный Тогда
	
		НаписатьПользователю(ТекущееСостояние, ЗаписьБеседы);
	
	КонецЕсли;
	
	Возврат ВозвращаемоеСостояние;
	
КонецФункции

// Возвращает пустую таблицу состояний чат-бота.
//
// Возвращаемое значение:
//  ТаблицаЗначений с колонками:
//    * Наименование - Строка - Наименование состояния
//    * Родитель - СправочникССылка.СостоянияЧатБота - Родитель данного состояния
//    * Высказывание - Строка - Высказывания данного состояния, разделенные "#"
//    * Действие - Строка - Действие данного состояния
//    * ТипСостояния - ПеречислениеСсылка.ТипыСостоянийЧатБота - Тип состояния
//    * ДоступноИзЛюбогоСостояния - Если Истина, значит к состоянию можно обратиться
//        из любого другого состояния
//    * Ссылка - СправочникСсылка.СостоянияЧатБота - Ссылка на данное состояние
//    * Теги - Строка - Теги состояния разделенные "#"
//    * Предопределенный - Булево - Если Истина, значит состояние предопределенное
//
Функция НоваяТаблицаСостояний() Экспорт

	ТаблицаСостояний = Новый ТаблицаЗначений;
	ТаблицаСостояний.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка"));
	ТаблицаСостояний.Колонки.Добавить("Родитель", Новый ОписаниеТипов("СправочникСсылка.СостоянияЧатБота"));
	ТаблицаСостояний.Колонки.Добавить("Высказывание", Новый ОписаниеТипов("Строка"));
	ТаблицаСостояний.Колонки.Добавить("Действие", Новый ОписаниеТипов("Строка"));
	ТаблицаСостояний.Колонки.Добавить("ТипСостояния", Новый ОписаниеТипов("ПеречислениеСсылка.ТипыСостоянийЧатБота"));
	ТаблицаСостояний.Колонки.Добавить("ДоступноИзЛюбогоСостояния", Новый ОписаниеТипов("Булево"));
	ТаблицаСостояний.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("СправочникСсылка.СостоянияЧатБота"));
	ТаблицаСостояний.Колонки.Добавить("Теги", Новый ОписаниеТипов("Строка"));
	ТаблицаСостояний.Колонки.Добавить("Предопределенный", Новый ОписаниеТипов("Булево"));
	ТаблицаСостояний.Колонки.Добавить("Вложения", Новый ОписаниеТипов("Массив"));
	
	Возврат ТаблицаСостояний;
	
КонецФункции

// Проверяет наличие обсуждения текущего пользователя с чат-ботом.
//
// Возвращаемое значение:
//  Булево - Истина, если существует обсуждение текущего пользователя с чат-ботом
//
Функция ОбсуждениеСБотомСуществует() Экспорт

	Отбор = Новый ОтборОбсужденийСистемыВзаимодействия();
	Отбор.Групповое = Ложь;
	Отбор.КонтекстноеОбсуждение = Ложь;
	Отбор.ТекущийПользовательЯвляетсяУчастником = Истина;
	Отбор.Отображаемое = Истина;
	
	Обсуждения = СистемаВзаимодействия.ПолучитьОбсуждения(Отбор);
	
	Для Каждого Обсуждение Из Обсуждения Цикл
	
		Если ЭтоОбсуждениеМеждуБотомИПользователем(Обсуждение) Тогда
		
			Возврат Истина;
		
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат Ложь;

КонецФункции

// Проверяет, что чат бот запущен
//
// Возвращаемое значение:
//  Булево - см. РаботаСЧатБотомВызовСервера.ЧатБотЗапущен
//
Функция ЧатБотЗапущен() Экспорт

	Возврат РаботаСЧатБотомПовтИсп.ЕстьАктивныеСостояния() И ЧатБотИспользуется();

КонецФункции

// Возвращает параметры состояния
//
// Параметры:
//  Состояние - СправочникСсылка.СостоянияЧатБота - состояние чат-бота
//
// Возвращаемое значение:
//  Структура - в качестве ключа передается Имя параметра, 
//    в качестве значения - значение параметра
//
Функция ПараметрыСостояния(Состояние) Экспорт
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	СостоянияЧатБотаПараметры.ИмяПараметра КАК Имя,
	               |	СостоянияЧатБотаПараметры.Значение КАК Значение,
	               |	ВЫБОР
	               |		КОГДА ТИПЗНАЧЕНИЯ(СостоянияЧатБотаПараметры.Значение) = ТИП(Справочник.ВычисляемыеПараметрыЧатБота)
	               |			ТОГДА СостоянияЧатБотаПараметры.Значение.Скрипт
	               |		ИНАЧЕ """"
	               |	КОНЕЦ КАК Скрипт
	               |ИЗ
	               |	Справочник.СостоянияЧатБота.Параметры КАК СостоянияЧатБотаПараметры
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СостоянияЧатБота КАК СостоянияЧатБота
	               |		ПО СостоянияЧатБотаПараметры.Ссылка = СостоянияЧатБота.Ссылка
	               |ГДЕ
	               |	СостоянияЧатБота.Ссылка = &Ссылка";
	Запрос.Параметры.Вставить("Ссылка", Состояние);
	Параметры = Запрос.Выполнить().Выбрать();
	
	ПараметрыДействия = Новый Структура();
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Для Каждого ИмяРазделителя Из РаботаВМоделиСервиса.РазделителиКонфигурации() Цикл
			УстановитьБезопасныйРежимРазделенияДанных(ИмяРазделителя, Истина);
		КонецЦикла;
		УстановитьБезопасныйРежим(Истина);
	КонецЕсли;
	
	Пока Параметры.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Параметры.Скрипт) Тогда
		
			ЗначениеПараметра = "";
			Выполнить(Параметры.Скрипт);
			ПараметрыДействия.Вставить(Параметры.Имя, ЗначениеПараметра);
			
		Иначе 
			
			ПараметрыДействия.Вставить(Параметры.Имя, Параметры.Значение);
			
		КонецЕсли; 
		
	КонецЦикла;
		
	Возврат ПараметрыДействия;
	
КонецФункции

// Проверяет, нужно ли начинать диалог с пользователем с начала
//
// Параметры: 
//  ТекущееСостояние - СправочникССылка.СостоянияЧатБота - ТекущееСостояние чат-бота
//
// Возвращаемое значение:
//  Булево - Истина, если с последнего сообщения прошло больше 15 минут 
//   или у текущего состояния нет подчиненных
//
Функция НачатьДиалогЗаново(ТекущееСостояние = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НетПодчиненных = Истина;
	Если ЗначениеЗаполнено(ТекущееСостояние) Тогда 
		ЗапросПодчиненных = Новый Запрос();
		ЗапросПодчиненных.Текст = 
		"ВЫБРАТЬ
		|	ИСТИНА 
		|ИЗ
		|	Справочник.СостоянияЧатБота КАК СостоянияЧатБота
		|ГДЕ
		|	НЕ СостоянияЧатБота.ПометкаУдаления
		|	И СостоянияЧатБота.Родитель = &Родитель";
		
		Если Не ЭтоАдминистраторЧатБота() Тогда
			ЗапросПодчиненных.Текст = ЗапросПодчиненных.Текст + " 
			|И СостоянияЧатБота.Используется";
		КонецЕсли;
		ЗапросПодчиненных.УстановитьПараметр("Родитель", ТекущееСостояние);
		Результат = ЗапросПодчиненных.Выполнить();
	
		НетПодчиненных = Результат.Пустой();
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Истина 
		|ИЗ
		|	РегистрСведений.ИсторияБеседСЧатБотом КАК ИсторияБеседСЧатБотом
		|ГДЕ
		|	ИсторияБеседСЧатБотом.Пользователь = &Пользователь
		|	И ИсторияБеседСЧатБотом.Период >= &Дата";
	
	Запрос.УстановитьПараметр("Пользователь", ПользователиКлиентСервер.ТекущийПользователь());
	Запрос.УстановитьПараметр("Дата", ТекущаяДатаСеанса() - 5 * 60);
	Результат = Запрос.Выполнить();
	
	Возврат Результат.Пустой() Или НетПодчиненных;

КонецФункции

Функция ЭтоАдминистраторЧатБота() Экспорт 

	Возврат РольДоступна("АдминистраторЧатБота") Или РольДоступна("ПолныеПрава") ;

КонецФункции

// Проверяет используется ли чат-бот
//
// Возвращаемое значени:
//  Булево - Истина, если ИспользоватьЧатБота = Истина.
Функция ЧатБотИспользуется() Экспорт

	УстановитьПривилегированныйРежим(Истина);
	ЧатБотИспользуется = Константы.ИспользоватьЧатБота.Получить();
	
	Возврат ЧатБотИспользуется;

КонецФункции

// Возвращает обсуждение Системы Взаимодействия между текущим пользователем и чат-ботом
//
// Возвращаемое значение:
//  ОбсуждениеСистемыВзаимодействия - 
//		Обсуждение системы взаимодействия между пользователем и чат-ботом
//
Функция ОбсуждениеТекущегоПользователяСБотом() Экспорт

	Пользователь = ПользователиКлиентСервер.ТекущийПользователь();
	ПользовательСВ = ОбсужденияДокументооборот.ИдентификаторПользователяСВ(Пользователь);
	ЧатБот = РаботаСЧатБотомПовтИсп.ЧатБот();
	ЧатБотСВ = ОбсужденияДокументооборот.ИдентификаторПользователяСВ(ЧатБот);
	
	Возврат ОбсужденияДокументооборот.ЛичноеОбсуждениеПользователей(ПользовательСВ, ЧатБотСВ);

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Переходит на следующее состояние. 
//  Если СостоянияДляУточнения не пусто, тогда выбор следующего происходит из
//  них, иначе выбираем среди всех потомков текущего сосотояния. 
//  Если не нашли подходящих состояний, проверяем те, что доступны из любого состояния.
//  Если не нашли, ищем среди предопределенных состояний.
//  Переход осуществляется изменением ТекущегоСостояния
//
// Параметры:
//  ТекущееСостояние - СправочникСсылка.СостоянияЧатБота - текущее состояние чат-бота.
//  Текст - Строка - Текст сообщения пользователя
//  СостоянияДляУсточнения - Массив из СправочникСсылка.СостоянияЧатБота - массив состояний, которые чат-бот
//    признал равновероятными для перехода.
//  ЗаписьБеседы - Структура - см. РаботаСЧатБотомКлиентСервер.НоваяЗаписьБеседы
Процедура ПерейтиНаСледующееСостояние(ТекущееСостояние, Текст, СостоянияДляУточнения, ЗаписьБеседы)
		
	Если СостоянияДляУточнения.Количество() = 0 Тогда
		
		ОтборПоРодителюИПредопределенным = Новый Структура();
		ОтборПоРодителюИПредопределенным.Вставить("Родитель", ТекущееСостояние);
		ОтборПоРодителюИПредопределенным.Вставить("Предопределенный", Ложь);
		
		Переходы = ВыбратьСостоянияПоОтбору(ОтборПоРодителюИПредопределенным, Текст, Истина);
		
	Иначе
		
		Переходы = ВыбратьСостоянияПоОтбору(СостоянияДляУточнения, Текст, Истина);
		
	КонецЕсли;
	
	Если Переходы.Количество() = 0 Тогда
	
		ОтборПоПредопределенным = Новый Структура("Предопределенный", Истина);
		Переходы = ВыбратьСостоянияПоОтбору(ОтборПоПредопределенным, Текст);
	
	КонецЕсли;
	
	// На основе количества найденных подходящих состояний выбираем, что делать дальше
	Если Переходы.Количество() = 0 Тогда
		
		ТекущееСостояние = Справочники.СостоянияЧатБота.НеНайдено;
		
	ИначеЕсли Переходы.Количество() = 1 Тогда
	
		ТекущееСостояние = Переходы[0].Ссылка;
		СостоянияДляУточнения.Очистить();
		
	Иначе
		
		СостоянияДляУточнения.Очистить();
		
		Для Каждого Переход Из Переходы Цикл
		
			СостоянияДляУточнения.Добавить(Переход.Ссылка);
			
		КонецЦикла;
		
		ЗаписьБеседы.СостояниеВ = ТекущееСостояние;
		УточнитьСледующееСостояние(СостоянияДляУточнения, ЗаписьБеседы);
		
	КонецЕсли;
	
КонецПроцедуры 

// Выбирает состояния по отбору и проверяет каждое из них на возможность перехода
//
// Параметры:
//  Отбор - Структура, Массив - Задают условия поиска среди состояний чат-бота.
//  Текст - Строка - Сообщение пользователя
//
// Возвращаемое значение:
//  ТаблицаЗначений - см. НоваяТаблицаСостояний
//
Функция ВыбратьСостоянияПоОтбору(Отбор, Текст, ВыбиратьДоступныеИзЛюбогоСостояния = Ложь) 
	
	Переходы = НоваяТаблицаСостояний();
	Переходы.Колонки.Добавить("КоличествоОбщихСлов");
	Переходы.Колонки.Добавить("СуммарноеРасстояние");
	
	ТаблицаСостояний = СостоянияЧатБота(); 
	
	Если ТипЗнч(Отбор) = Тип("Структура") Тогда
	
		Состояния = ТаблицаСостояний.НайтиСтроки(Отбор);
		
		Если Отбор.Свойство("Родитель") 
			И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Отбор.Родитель, "ТипСостояния") 
				= Перечисления.ТипыСостоянийЧатБота.Вопрос Тогда
				
			Если Состояния.Количество() Тогда
			
				Строка = Переходы.Добавить();
				ЗаполнитьЗначенияСвойств(Строка, Состояния[0]);
			
			КонецЕсли;
			
			Возврат Переходы;
		
		КонецЕсли;
		
	Иначе
		
		Если Отбор.Количество() * ТаблицаСостояний.Количество() > 1000 Тогда
		
			ТаблицаСостояний.Индексы.Добавить("Ссылка");
		
		КонецЕсли; 
		
		Состояния = Новый Массив();
		
		Для Каждого Состояние Из Отбор Цикл
			
			ОтборПоСсылке = Новый Структура("Ссылка", Состояние);
			Состояния.Добавить(ТаблицаСостояний.НайтиСтроки(ОтборПоСсылке)[0]);
		
		КонецЦикла;
		
	КонецЕсли;
	
	Если ВыбиратьДоступныеИзЛюбогоСостояния Тогда
	
		ОтборДоступныхИхЛюбогоМеста = Новый Структура("ДоступноИзЛюбогоСостояния", Истина);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
			Состояния, ТаблицаСостояний.НайтиСтроки(ОтборДоступныхИхЛюбогоМеста), Истина);
	
	КонецЕсли;
	
	Для Каждого Состояние Из Состояния Цикл
	
		РангСостояния = РангСостояния(Текст, Состояние.Теги);
		
		Если РангСостояния.КоличествоОбщихСлов Тогда
		
			Строка = Переходы.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, Состояние);
			ЗаполнитьЗначенияСвойств(Строка, РангСостояния);
		
		КонецЕсли; 
	
	КонецЦикла;
	
	Переходы.Сортировать("КоличествоОбщихСлов Убыв, СуммарноеРасстояние Возр");
	
	Пока Переходы.Количество() > 1
		И (Переходы[Переходы.Количество() - 1].КоличествоОбщихСлов < Переходы[0].КоличествоОбщихСлов 
		Или Переходы[Переходы.Количество() - 1].СуммарноеРасстояние > Переходы[0].СуммарноеРасстояние)  Цикл
	
		Переходы.Удалить(Переходы.Количество() - 1);
	
	КонецЦикла;
	
	Возврат Переходы;

КонецФункции 

// Отправляет сообщение с уточнением, в какое состояния следует перейти.
//
// Параметры:
//  СостоянияДляУсточнения - Массив из СправочникСсылка.СостоянияЧатБота - массив состояний, которые чат-бот
//    признал равновероятными для перехода.
//  ЗаписьБеседы - Структура - см. РаботаСЧатБотомКлиентСервер.НоваяЗаписьБеседы
Процедура УточнитьСледующееСостояние(СостоянияДляУточнения, ЗаписьБеседы)
	
	Действия = СостоянияДляПоказа(СостоянияДляУточнения);
	Текст = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.СостоянияЧатБота.Уточнение, "Высказывание");
	
	ОтправитьСообщение(ПользователиКлиентСервер.ТекущийПользователь(), Текст,, Действия, ЗаписьБеседы);
	
КонецПроцедуры 

Функция РангСостояния(Текст, Теги)
	
	Текст = ВРег(Текст);
	Теги = ВРег(Теги);
	СловаВТексте = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивСлов(Текст);
	СловаВТегах = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивСлов(Теги);
	КоличествоСловВТексте = СловаВТексте.Количество();
	ВхожденияИРасстояние = Новый Массив();
	КоличествоВхождений = 0;
	СуммарноеРасстояние = 0;
	
	Для Индекс = 0 По КоличествоСловВТексте - 1 Цикл
	
		 ВхожденияИРасстояние.Добавить(Новый Структура("ЕстьВхождение, Расстояние", Ложь, 100000));
	
	КонецЦикла;

	ПорогДлины = ПорогДлиныСлова();
	Для Каждого Тег Из СловаВТегах Цикл
		
		ДопустимоеРасстояние = 0.1;
		
		Для а = 0 По КоличествоСловВТексте - 1 Цикл
			
			Если СтрДлина(СловаВТексте[а]) <= ПорогДлины 
				Или СтрДлина(Тег) <= ПорогДлины Тогда
			
				Если СловаВТексте[а] = Тег Тогда
				
					Расстояние = 0;
					
				Иначе 
					
					Расстояние = 100000;
					
				КонецЕсли; 
				
			Иначе
				
				Расстояние = Мин(РасстояниеДжароВинклера(СловаВТексте[а], Тег),
					РасстояниеДжароВинклера(Тег, СловаВТексте[а]));
				
			КонецЕсли;
			
			Если Расстояние <= ДопустимоеРасстояние Тогда
				
				ВхожденияИРасстояние[а].ЕстьВхождение = Истина;
				ВхожденияИРасстояние[а].Расстояние = 
					Мин(ВхожденияИРасстояние[а].Расстояние, Расстояние);
			
			КонецЕсли;
		
		КонецЦикла;
		
	КонецЦикла;
	
	Результат = Новый Структура();
	Результат.Вставить("КоличествоОбщихСлов", 0);
	Результат.Вставить("СуммарноеРасстояние", 0);
	
	Для а = 0 По КоличествоСловВТексте - 1 Цикл
	
		Если ВхожденияИРасстояние[а].ЕстьВхождение Тогда
		
			Результат.КоличествоОбщихСлов = Результат.КоличествоОбщихСлов + 1;
			Результат.СуммарноеРасстояние = Результат.СуммарноеРасстояние + ВхожденияИРасстояние[а].Расстояние;
		
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Проверяет что данное обсуждение личное между текущим пользователем и чат-ботом
//
//Параметры: 
//	ИдентификаторОбсуждения - ОбсуждениеСиситемыВзаимодействия, ИдентификаторОбсужденияСистемыВзаимодействия - 
//		Обсуждение для которого требуется проверить наличие в нем чат-бота и текущего пользователя.
//
//Возвращаемое значение:
//	Булево - Истина, если в данном обсуждении только чат-бот и текущий пользователь
//
Функция ЭтоОбсуждениеМеждуБотомИПользователем(ИдентификаторОбсуждения)

	Если ТипЗнч(ИдентификаторОбсуждения) = Тип("ИдентификаторОбсужденияСистемыВзаимодействия") Тогда
	
		Обсуждение = СистемаВзаимодействия.ПолучитьОбсуждение(ИдентификаторОбсуждения);
		
	Иначе 
		
		Обсуждение = ИдентификаторОбсуждения;
		
	КонецЕсли; 
	
	Если Обсуждение.Групповое Тогда 
		
		Возврат Ложь; 
		
	КонецЕсли;
	
	Участники = Обсуждение.Участники;
	ЧатБот = РаботаСЧатБотомПовтИсп.ИДентификаторБотаСВ();
	Пользователь = ОбсужденияДокументооборот.ИдентификаторПользователяСВ(
		ПользователиКлиентСервер.ТекущийПользователь());
	
	ЧатБотВОбсуждении = Ложь;
	ПользовательВОбсуждении = Ложь;
	
	Для Каждого Участник Из Участники Цикл
	
		Если Участник = ЧатБот Тогда
		
			ЧатБотВОбсуждении = Истина;	
		
		КонецЕсли;
		
		Если Участник = Пользователь Тогда
		
			ПользовательВОбсуждении = Истина;
		
		КонецЕсли; 
		
	КонецЦикла;
	
	Возврат ЧатБотВОбсуждении И ПользовательВОбсуждении;

КонецФункции

Функция ПодготовитьВложенияКОтправкеЧерезСВ(Вложения)
	
	Если Не ЗначениеЗаполнено(Вложения) Тогда
	
		Возврат Неопределено;
	
	КонецЕсли;
	
	ВложенияСВ = Новый Массив();
	ТекстВложений = "";
	
	Для Каждого Вложение Из Вложения Цикл
		
		Попытка
			
			Если ТипЗнч(Вложение) = Тип("СправочникСсылка.Файлы") Тогда
			
				ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДвоичныеДанныеФайла(Вложение);
				РеквизитыФайла = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Вложение, "Наименование, ТекущаяВерсияРасширение");
				ИмяСРасширением = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
					РеквизитыФайла.Наименование, РеквизитыФайла.ТекущаяВерсияРасширение);
				ВложенияСВ.Добавить(ВложениеЧатБота(ИмяСРасширением, ДанныеФайла));
				
			ИначеЕсли ТипЗнч(Вложение) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
				ТекстВложений = ТекстВложений + ПолучитьНавигационнуюСсылку(Вложение) + Символы.ПС;
			Иначе
				
				ДанныеФайла = ?(Вложение.Свойство("Ссылка"),
					РаботаСФайламиВызовСервера.ПолучитьДвоичныеДанныеФайла(Вложение),
					Вложение.ДанныеФайла);
				ВложенияСВ.Добавить(ВложениеЧатБота(СокрЛП(Вложение), ДанныеФайла));
			КонецЕсли;
		
		Исключение
		
		КонецПопытки;
	
	КонецЦикла; 
	
	Возврат Новый Структура("ВложенияСВ, ТекстВложений", ВложенияСВ, ТекстВложений);
	
КонецФункции

// Возвращает таблицу состояний чат-бота.
//
// Возвращаемое значение:
//  ТаблицаЗначений - см. РаботаСЧатБотом.НоваяТаблицаСостояний
//
Функция СостоянияЧатБота()
	
	СостоянияЧатБота = РаботаСЧатБотом.НоваяТаблицаСостояний();
	
	Запрос = Новый Запрос();
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СостоянияЧатБота.Ссылка КАК Ссылка,
		|	СостоянияЧатБота.Родитель.Ссылка КАК Родитель,
		|	СостоянияЧатБота.Наименование КАК Наименование,
		|	СостоянияЧатБота.ТипСостояния КАК ТипСостояния,
		|	СостоянияЧатБота.Действие КАК Действие,
		|	СостоянияЧатБота.ДоступноИзЛюбогоСостояния КАК ДоступноИзЛюбогоСостояния,
		|	СостоянияЧатБота.Предопределенный КАК Предопределенный,
		|	СостоянияЧатБота.КлючевыеСлова КАК Теги,
		|	СостоянияЧатБота.Высказывание КАК Высказывание,
		|	СостоянияЧатБотаВложения.Вложение КАК Вложение
		|ИЗ
		|	Справочник.СостоянияЧатБота КАК СостоянияЧатБота
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СостоянияЧатБота.Вложения КАК СостоянияЧатБотаВложения
		|		ПО (СостоянияЧатБотаВложения.Ссылка = СостоянияЧатБота.Ссылка)
		|ГДЕ
		|	СостоянияЧатБота.ПометкаУдаления = ЛОЖЬ";
	
	Если Не ЭтоАдминистраторЧатБота() Тогда
		Запрос.Текст = Запрос.Текст + " 
		|И СостоянияЧатБота.Используется";
	КонецЕсли;
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	Для Каждого Эл Из Результат Цикл
		
		ОтборПоСсылке = Новый Структура("Ссылка", Эл.Ссылка);
		РезультатОтбора = СостоянияЧатБота.НайтиСтроки(ОтборПоСсылке);
		
		Если РезультатОтбора.Количество() = 0 Тогда
			
			Состояние = СостоянияЧатБота.Добавить();
			ЗаполнитьЗначенияСвойств(Состояние, Эл);
			Состояние.Теги = СтрЗаменить(Состояние.Теги, Символы.ПС, "#");
			Если ЗначениеЗаполнено(Эл.Вложение) Тогда 
				Состояние.Вложения.Добавить(Эл.Вложение);
			КонецЕсли;
			
		Иначе
			
			СтрокаСостояния = РезультатОтбора[0];
			
			Если ЗначениеЗаполнено(Эл.Вложение) Тогда
				СтрокаСостояния.Вложения.Добавить(Эл.Вложение);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СостоянияЧатБота;
	 
КонецФункции

Функция ПервоеСообщениеЧатБота()

	УстановитьПривилегированныйРежим(Истина);
	ПервоеСообщениеЧатБота = Константы.ПервоеСообщениеЧатБота.Получить();
	Возврат ПервоеСообщениеЧатБота;

КонецФункции

Функция ПорогДлиныСлова()

	Возврат 4;

КонецФункции

//Возвращает сходство Джаро-Винклера (Jaro-Winkler similarity) между строками.
Функция РасстояниеДжароВинклера(Строка1, Строка2)
	
	Если Строка1 = Строка2 Тогда
	
		Возврат 0;
	
	КонецЕсли; 
	
	Длина1 = СтрДлина(Строка1);
	Длина2 = СтрДлина(Строка2);
	РасстояниеСовпаденияСимв = Цел(Макс(Длина1, Длина2) / 2) - 1;
	КоличествоСовпадающих = 0;
	КоличествоТранспозиций = 0;
	ДлинаОбщегоПрефикса = 0;
	КоэфМасштабирования = 0.1;
	ПорогУсиления = 0.7;
	
	БуферСимволов = Новый Соответствие();
	
	Для а = 1 По Длина1 Цикл
	
		Символ1 = Сред(Строка1, а, 1);
		
		Для б = 1 По Длина2 Цикл
		
			Если б < а - РасстояниеСовпаденияСимв Тогда
			
				Продолжить;
			
			КонецЕсли;
			
			Если б > а + РасстояниеСовпаденияСимв Тогда
			
				Прервать;
			
			КонецЕсли;
			
			Символ2 = Сред(Строка2, б, 1);
			
			Если Символ1 = Символ2 Тогда
			
				Если БуферСимволов.Получить(б) = Символ1 Тогда
				
					Продолжить;
					
				Иначе
					
					БуферСимволов.Вставить(б, Символ1);
					КоличествоСовпадающих = КоличествоСовпадающих + 1;
					
					Если а <> б Тогда
						
						КоличествоТранспозиций = КоличествоТранспозиций + 1;
					
					КонецЕсли; 
				
				КонецЕсли;
			
			КонецЕсли; 
		
		КонецЦикла;
	
	КонецЦикла; 
	
	Пока ДлинаОбщегоПрефикса < 4 
		И Сред(Строка1, ДлинаОбщегоПрефикса + 1, 1) = Сред(Строка2, ДлинаОбщегоПрефикса + 1, 1) Цикл
		
		ДлинаОбщегоПрефикса = ДлинаОбщегоПрефикса + 1;
	
	КонецЦикла;
	
	РасстояниеДжароВинклера = 0;
	
	Если КоличествоСовпадающих > 0 Тогда
	
		ПоловинаТранспозиций = Цел(КоличествоТранспозиций / 2);
		РасстояниеДжаро = (КоличествоСовпадающих / Длина1 
						+ КоличествоСовпадающих / Длина2
						+ (КоличествоСовпадающих - ПоловинаТранспозиций) / КоличествоСовпадающих) / 3;
						
		Если РасстояниеДжаро > ПорогУсиления Тогда
		
			РасстояниеДжароВинклера = РасстояниеДжаро 
									+ (ДлинаОбщегоПрефикса * КоэфМасштабирования * (1 - РасстояниеДжаро));
			
		Иначе
			
			РасстояниеДжароВинклера = РасстояниеДжаро;
		
		КонецЕсли; 
	
	КонецЕсли; 
	
	Возврат 1 - РасстояниеДжароВинклера;

КонецФункции

// Возвращает состояния списком значений.
Функция СостоянияДляПоказа(Состояния)

	Действия = Новый СписокЗначений;
	РеквизитыСостояния = Неопределено;
	
	Если ТипЗнч(Состояния) = Тип("Массив") Тогда
	
		РеквизитыСостояний = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(
			Состояния, "Ссылка, Наименование, Действие, ТипСостояния");
			
	Иначе 
		
		РеквизитыСостояний = Состояния;
		
	КонецЕсли; 
	
	Для Каждого РеквизитыСостояния Из РеквизитыСостояний Цикл
		
		Состояние = Неопределено;
		
		Если ТипЗнч(Состояния) = Тип("Массив") Тогда
		
			Состояние = РеквизитыСостояния.Значение;
			
		Иначе
			
			Состояние = РеквизитыСостояния;
			
		КонецЕсли; 
		
		Действия.Добавить(Состояние.Ссылка, Состояние.Наименование);
		
	КонецЦикла;
	
	Действия.СортироватьПоПредставлению();
	
	ДействияКоличество = Действия.Количество();
	
	Для Индекс = 1 По ДействияКоличество - 1 Цикл
	
		Действия[Индекс].Представление = Символы.ПС + Действия[Индекс].Представление;
	
	КонецЦикла; 
	
	Возврат Действия;

КонецФункции

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Для Каждого ТипУЗ Из ТипыУчетныхЗаписей() Цикл
		Элементы.ТипУчетнойЗаписи.СписокВыбора.Добавить(ТипУЗ.Значение,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Календарь %1'"), ТипУЗ.Значение));
	КонецЦикла;
	Для Каждого ВидЗагрузки Из ВидыЗагрузкиКалендарей() Цикл
		Элементы.КалендариПодключениеВидЗагрузки.СписокВыбора.Добавить(ВидЗагрузки.Значение, ВидЗагрузки.Значение);
		Элементы.КалендариНастройкаВидЗагрузки.СписокВыбора.Добавить(ВидЗагрузки.Значение, ВидЗагрузки.Значение);
	КонецЦикла;
	ТипУчетнойЗаписи = Элементы.ТипУчетнойЗаписи.СписокВыбора[0].Значение;
	ЗаполнитьНаСервере();
	ОбновитьВидимостьЭлементов(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если СтатусСинхронизации = СтатусыСинхронизации()["НастроенаПодключение"] Тогда
		ПодключитьНаКлиенте();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)

	Если СтатусСинхронизации = СтатусыСинхронизации()["НеНастроена"] Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Для сохранения необходимо завершить подключение, нажав на кнопку ""Подключить"".'"));
		Отказ = Истина;
	ИначеЕсли СтатусСинхронизации = СтатусыСинхронизации()["НеНастроенаПодключение"]
			Или СтатусСинхронизации = СтатусыСинхронизации()["НеНастроенаОшибка"] Тогда
		Если ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["iCloud"] Тогда
			Если Не ЗначениеЗаполнено(ЛогинiCloud) ИЛИ Не ЗначениеЗаполнено(ПарольiCloud) Тогда
				СтатусСинхронизации = СтатусыСинхронизации()["НеНастроенаОшибка"];
				ТекущееОписаниеОшибки = НСтр("ru = 'Введите имя пользователя и пароль'");
				ОбновитьВидимостьЭлементов(ЭтаФорма);
				Отказ = Истина;
			КонецЕсли;
		ИначеЕсли ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["Google"] Тогда
			Если Не ЗначениеЗаполнено(КодРазрешенияGoogle) Тогда
				СтатусСинхронизации = СтатусыСинхронизации()["НеНастроенаОшибка"];
				ТекущееОписаниеОшибки = НСтр("ru = 'Укажите код разрешения для доступа к календарю'");
				ОбновитьВидимостьЭлементов(ЭтаФорма);
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли СтатусСинхронизации = СтатусыСинхронизации()["ПодключениеУстановлено"] Тогда
		Если Не ЗначениеЗаполнено(КалендарьДляЗаписи) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не выбран календарь для записи'"), , "КалендарьДляЗаписиПодключение");
			Отказ = Истина;
		КонецЕсли;
	ИначеЕсли СтатусСинхронизации = СтатусыСинхронизации()["НастроенаПодключение"]
			Или СтатусСинхронизации = СтатусыСинхронизации()["НастроенаПодключена"]
			Или СтатусСинхронизации = СтатусыСинхронизации()["НастроенаОтключена"]
			Или СтатусСинхронизации = СтатусыСинхронизации()["НастроенаОшибка"] Тогда
		Если Не ЗначениеЗаполнено(КалендарьДляЗаписи) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не выбран календарь для записи'"), , "КалендарьДляЗаписиНастройка");
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	Если Модифицированность Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбработкаВопросаПередЗакрытием", ЭтотОбъект),
			НСтр("ru = 'Данные были изменены. Сохранить изменения?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
		Отказ = Истина;
	КонецЕсли;
	Оповестить("Закрытие_НастройкиСинхронизацииКалендаря");

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТипУчетнойЗаписиПриИзменении(Элемент)

	ЗаполнитьНаСервере();
	ОбновитьВидимостьЭлементов(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура КалендарьДляЗаписиПриИзменении(Элемент)

	Для Каждого СтрокаКалендари Из Календари Цикл
		СтрокаКалендари.Изменение = (СтрокаКалендари.Идентификатор = КалендарьДляЗаписи);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура КалендариПодключениеВидЗагрузкиПриИзменении(Элемент)
	ПриИзмененииВидаЗагрузки(Элементы.КалендариПодключение.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура КалендариНастройкаВидЗагрузкиПриИзменении(Элемент)
	ПриИзмененииВидаЗагрузки(Элементы.КалендариНастройка.ТекущиеДанные);
КонецПроцедуры

&НаКлиенте
Процедура ПолучатьУведомленияЭкспортПодключениеПриИзменении(Элемент)
	Элементы.ВремяУведомленийЭкспортПодключение.Доступность = ПолучатьУведомленияЭкспорт;
КонецПроцедуры

&НаКлиенте
Процедура ПолучатьУведомленияИмпортПодключениеПриИзменении(Элемент)
	Элементы.ВремяУведомленийИмпортПодключение.Доступность = ПолучатьУведомленияИмпорт;
КонецПроцедуры

&НаКлиенте
Процедура ПолучатьУведомленияЭкспортНастройкаПриИзменении(Элемент)
	Элементы.ВремяУведомленийЭкспортНастройка.Доступность = ПолучатьУведомленияЭкспорт;
КонецПроцедуры

&НаКлиенте
Процедура ПолучатьУведомленияИмпортНастройкаПриИзменении(Элемент)
	Элементы.ВремяУведомленийИмпортНастройка.Доступность = ПолучатьУведомленияИмпорт;
КонецПроцедуры

&НаКлиенте
Процедура ДатаСинхронизацииПриИзменении(Элемент)
	
	МаксВозраст = ТекущаяДата() - 31536000;
	Если ДатаСинхронизации < МаксВозраст Тогда
		ДатаСинхронизации = МаксВозраст;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьКодРазрешенияGoogle(Команда)

	НавигационнаяСсылкаНаСайтGoogle = АдресЗапросаНаПодтверждениеДоступа();
	ПерейтиПоНавигационнойСсылке(НавигационнаяСсылкаНаСайтGoogle);

КонецПроцедуры

&НаКлиенте
Процедура Подключить(Команда)

	Если СтатусСинхронизации = СтатусыСинхронизации()["НастроенаОтключена"]
			Или СтатусСинхронизации = СтатусыСинхронизации()["НастроенаОшибка"] Тогда
		СтатусСинхронизации = СтатусыСинхронизации()["НастроенаПодключение"];
	Иначе
		СтатусСинхронизации = СтатусыСинхронизации()["НеНастроенаПодключение"];
	КонецЕсли;
	ПодключитьНаКлиенте();

КонецПроцедуры

&НаКлиенте
Процедура Отключить(Команда)

	ОтключитьНаСервере();
	ОбновитьВидимостьЭлементов(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура Удалить(Команда)

	ПоказатьВопрос(Новый ОписаниеОповещения("ОбработкаВопросаУдаление", ЭтотОбъект),
		НСтр("ru = 'Будут удалены все данные пользователя о подключении. Продолжить?'"),
		РежимДиалогаВопрос.ДаНет);

КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)

	СохранитьНаСервере();
	СинхронизироватьКалендариНаКлиенте();
	СтатусСинхронизации = СтатусыСинхронизации()["НастроенаПодключена"];
	ОбновитьВидимостьЭлементов(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура СинхронизироватьКалендарь(Команда)

	СинхронизироватьКалендариНаКлиенте();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ЛокальныеПеречисления

&НаКлиентеНаСервереБезКонтекста
Функция СтатусыСинхронизации()

	СтатусыСинхронизации = Новый Структура;
	СтатусыСинхронизации.Вставить("НеНастроена",				"НеНастроена");
	СтатусыСинхронизации.Вставить("НеНастроенаПодключение",		"НеНастроенаПодключение");
	СтатусыСинхронизации.Вставить("НеНастроенаОшибка",			"НеНастроенаОшибка");
	СтатусыСинхронизации.Вставить("ПодключениеУстановлено",		"ПодключениеУстановлено");
	СтатусыСинхронизации.Вставить("НастроенаПодключение",		"НастроенаПодключение");
	СтатусыСинхронизации.Вставить("НастроенаПодключена",		"НастроенаПодключена");
	СтатусыСинхронизации.Вставить("НастроенаОтключена",			"НастроенаОтключена");
	СтатусыСинхронизации.Вставить("НастроенаОшибка",			"НастроенаОшибка");
	Возврат СтатусыСинхронизации;

КонецФункции

&НаСервереБезКонтекста
Функция ТипыУчетныхЗаписей()

	Результат = Новый Структура;
	Результат.Вставить("Google", "Google");
	Результат.Вставить("iCloud", "iCloud");
	Возврат Результат;

КонецФункции

&НаСервереБезКонтекста
Функция ВидыЗагрузкиКалендарей()

	Результат = Новый Структура;
	Результат.Вставить(НСтр("ru = 'Полностью'"), НСтр("ru = 'Полностью'"));
	Результат.Вставить(НСтр("ru = 'БезОписания'"), НСтр("ru = 'Без описания'"));
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область ЗаполнениеНаСервере

&НаСервере
Процедура ЗаполнитьНаСервере()

	УчетнаяЗапись = ДанныеУчетнойЗаписи(Пользователи.ТекущийПользователь());
	ЗаполнитьОбщиеРеквизиты(УчетнаяЗапись);
	ЗаполнитьРеквизитыiCloud(УчетнаяЗапись);
	ЗаполнитьРеквизитыGoogle(УчетнаяЗапись);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ДанныеУчетнойЗаписи(Пользователь)

	УстановитьПривилегированныйРежим(Истина);
	Данные = Новый Структура;
	Запрос = Новый Запрос(
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	СинхронизацияКалендарей.Ссылка КАК Узел,
	|	СинхронизацияКалендарей.Включен КАК Включен,
	|	ВЫБОР
	|		КОГДА СинхронизацияКалендарей.ТипСинхронизации = ЗНАЧЕНИЕ(Перечисление.ТипыСинхронизацииКалендарей.Google)
	|			ТОГДА ""Google""
	|		КОГДА СинхронизацияКалендарей.ТипСинхронизации = ЗНАЧЕНИЕ(Перечисление.ТипыСинхронизацииКалендарей.DAV)
	|			ТОГДА ""iCloud""
	|		ИНАЧЕ """"
	|	КОНЕЦ КАК ТипУчетнойЗаписи,
	|	СинхронизацияКалендарей.ВремяУведомленийЭкспорт / 60 КАК ВремяУведомленийЭкспорт,
	|	СинхронизацияКалендарей.ВремяУведомленийИмпорт / 60 КАК ВремяУведомленийИмпорт,
	|	СинхронизацияКалендарей.ДатаПоследнейСинхронизации КАК ДатаПоследнейСинхронизации,
	|	СинхронизацияКалендарей.СинхронизацияЗавершенаСОшибками КАК СинхронизацияЗавершенаСОшибками,
	|	СинхронизацияКалендарей.ИнформацияОбОшибке КАК ИнформацияОбОшибке,
	|	СинхронизацияКалендарей.ДатаПервоначальнойСинхронизации КАК ДатаПервоначальнойСинхронизации
	|ИЗ
	|	ПланОбмена.СинхронизацияКалендарей КАК СинхронизацияКалендарей
	|ГДЕ
	|	СинхронизацияКалендарей.Пользователь = &Пользователь
	|	И НЕ СинхронизацияКалендарей.ПометкаУдаления");
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Если Выборка.ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["Google"] Тогда
			Данные = РегистрыСведений.НастройкиСинхронизацииGoogle.ДанныеАвторизации(Выборка.Узел);
		ИначеЕсли Выборка.ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["iCloud"] Тогда
			Данные = РегистрыСведений.НастройкиСинхронизацииDAV.ДанныеАвторизации(Выборка.Узел);
		КонецЕсли;
		Если ЗначениеЗаполнено(Данные) Тогда
			Для Каждого Колонка Из РезультатЗапроса.Колонки Цикл
				Данные.Вставить(Колонка.Имя, Выборка[Колонка.Имя]);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	Возврат Данные;

КонецФункции

&НаСервере
Процедура ЗаполнитьОбщиеРеквизиты(УчетнаяЗапись)
	
	СтатусСинхронизации = СтатусыСинхронизации()["НеНастроена"];
	Элементы.ГруппаУведомленияИмпортПодключение.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНапоминанияПользователя");
	Элементы.ГруппаУведомленияИмпортНастройка.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНапоминанияПользователя");
	Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, УчетнаяЗапись);
		ДатаСинхронизации = УчетнаяЗапись.ДатаПервоначальнойСинхронизации;
		ПолучатьУведомленияИмпорт = (ВремяУведомленийИмпорт > 0);
		ПолучатьУведомленияЭкспорт = (ВремяУведомленийЭкспорт > 0);
		Если УчетнаяЗапись.Включен Тогда
			СтатусСинхронизации = СтатусыСинхронизации()["НастроенаПодключение"];
			ЗаполнитьДанныеПоследнейСинхронизации(УчетнаяЗапись);
		Иначе
			СтатусСинхронизации = СтатусыСинхронизации()["НастроенаОтключена"];
		КонецЕсли;
		Включен = УчетнаяЗапись.Включен;
	Иначе
		ДатаСинхронизации = ТекущаяДатаСеанса();
		Узел = ПланыОбмена.СинхронизацияКалендарей.ПустаяСсылка();
		Элементы.КалендарьДляЗаписиПодключение.СписокВыбора.Очистить();
		Календари.Очистить();
		ПолучатьУведомленияИмпорт = Истина;
		ПолучатьУведомленияЭкспорт = Истина;
		ВремяУведомленийИмпорт = 15;
		ВремяУведомленийЭкспорт = 15;
		Включен = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеПоследнейСинхронизации(УчетнаяЗапись = Неопределено)
	
	Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		УчетнаяЗапись = ДанныеУчетнойЗаписи(Пользователи.ТекущийПользователь());
	КонецЕсли;
	Если Не ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(УчетнаяЗапись.ДатаПоследнейСинхронизации) Тогда
		Элементы.ДанныеПоследнейСинхронизации.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	Элементы.ГруппаСостояниеПоследнейСинхронизации.Видимость = Истина;
	Если УчетнаяЗапись.СинхронизацияЗавершенаСОшибками Тогда
		Элементы.ДанныеПоследнейСинхронизации.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Последняя синхронизация завершилась ошибкой: %1
						|%2'"), УчетнаяЗапись.ДатаПоследнейСинхронизации, УчетнаяЗапись.ИнформацияОбОшибке);
	Иначе
		Элементы.ДанныеПоследнейСинхронизации.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Последняя синхронизация: %1'"), УчетнаяЗапись.ДатаПоследнейСинхронизации);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыiCloud(УчетнаяЗапись)

	Если Не ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["iCloud"] Тогда
		Возврат;
	КонецЕсли;
	Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		СерверiCloud = УчетнаяЗапись.Сервер;
		ЛогинiCloud = УчетнаяЗапись.ИмяПользователя;
	Иначе
		СерверiCloud = СерверCalDAViCloud();
		ЛогинiCloud = "";
		ПарольiCloud = "";
		КаталогКалендарейiCloud = "";
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыGoogle(УчетнаяЗапись)

	Если Не ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["Google"] Тогда
		Возврат;
	КонецЕсли;
	Если ЗначениеЗаполнено(УчетнаяЗапись) Тогда
		ТокенДоступаGoogle = УчетнаяЗапись.ТокенДоступа;
		ТипТокенаДоступаGoogle = УчетнаяЗапись.ТипТокенаДоступа;
		ТокенОбновленияGoogle = УчетнаяЗапись.ТокенОбновления;
	Иначе
		КодРазрешенияGoogle = "";
		ТокенДоступаGoogle = "";
		ТипТокенаДоступаGoogle = "";
		ТокенОбновленияGoogle = "";
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция СерверCalDAViCloud()

	Возврат "https://caldav.icloud.com:443";

КонецФункции

#КонецОбласти

#Область УправлениеВидомФормы

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВидимостьЭлементов(Форма)

	ЭлементыФормы = Форма.Элементы;
	ТипУчетнойЗаписи = Форма.ТипУчетнойЗаписи;
	СтатусСинхронизации = Форма.СтатусСинхронизации;
	Если СтатусСинхронизации = СтатусыСинхронизации()["НеНастроена"]
			Или СтатусСинхронизации = СтатусыСинхронизации()["НеНастроенаПодключение"]
			Или СтатусСинхронизации = СтатусыСинхронизации()["НеНастроенаОшибка"]Тогда
		ЭлементыФормы.СтраницыФормы.ТекущаяСтраница = ЭлементыФормы.СтраницаВыборТипаУчетнойЗаписи;
		ИзменитьВидСтраницыВыбораУчетнойЗаписи(Форма);
	ИначеЕсли СтатусСинхронизации = СтатусыСинхронизации()["ПодключениеУстановлено"] Тогда
		ЭлементыФормы.СтраницыФормы.ТекущаяСтраница = ЭлементыФормы.СтраницаПодключение;
		ИзменитьВидСтраницыПодключения(Форма);
	ИначеЕсли СтатусСинхронизации = СтатусыСинхронизации()["НастроенаПодключение"]
			Или СтатусСинхронизации = СтатусыСинхронизации()["НастроенаПодключена"]
			Или СтатусСинхронизации = СтатусыСинхронизации()["НастроенаОтключена"]
			Или СтатусСинхронизации = СтатусыСинхронизации()["НастроенаОшибка"]Тогда
		ЭлементыФормы.СтраницыФормы.ТекущаяСтраница = ЭлементыФормы.СтраницаНастройка;
		ИзменитьВидСтраницыНастройки(Форма);
	КонецЕсли;
	Форма.ТекущееОписаниеОшибки = "";

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьВидСтраницыВыбораУчетнойЗаписи(Форма)
	
	ЭлементыФормы = Форма.Элементы;
	ТипУчетнойЗаписи = Форма.ТипУчетнойЗаписи;
	ЭлементГруппа = ЭлементыФормы["ГруппаПодключение" + ТипУчетнойЗаписи];
	ЭлементКнопка = ЭлементыФормы["Подключить" + ТипУчетнойЗаписи];
	ЭлементКартинка = ЭлементыФормы["СостояниеПодключения" + ТипУчетнойЗаписи];
	ЭлементНадпись = ЭлементыФормы["РезультатПодключения" + ТипУчетнойЗаписи];
	ЭлементыФормы.КартинкаЛоготип.Картинка = БиблиотекаКартинок[ТипУчетнойЗаписи + "Logo"];
	ЭлементыФормы.СтраницыУчетныеЗаписи.ТекущаяСтраница = ЭлементыФормы["Страница" + ТипУчетнойЗаписи];
	СтатусСинхронизации = Форма.СтатусСинхронизации;
	Если СтатусСинхронизации = СтатусыСинхронизации()["НеНастроена"] Тогда
		ЭлементГруппа.Видимость = Ложь;
		ЭлементКнопка.Видимость = Истина;
	ИначеЕсли СтатусСинхронизации = СтатусыСинхронизации()["НеНастроенаПодключение"] Тогда
		ЭлементКартинка.Картинка = БиблиотекаКартинок.ДлительнаяОперация24;
		ЭлементНадпись.Заголовок = НСтр("ru = 'Выполняется подключение...'");
		ЭлементГруппа.Видимость = Истина;
		ЭлементКнопка.Видимость = Ложь;
	ИначеЕсли СтатусСинхронизации = СтатусыСинхронизации()["НеНастроенаОшибка"] Тогда
		ЭлементКартинка.Картинка = БиблиотекаКартинок.КрасныйКрест;
		ЭлементНадпись.Заголовок = Форма.ТекущееОписаниеОшибки;
		ЭлементГруппа.Видимость = Истина;
		ЭлементКнопка.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьВидСтраницыПодключения(Форма)

	ЭлементыФормы = Форма.Элементы;
	ТипУчетнойЗаписи = Форма.ТипУчетнойЗаписи;
	ЭлементыФормы.НадписьСоединениеУстановлено.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Соединение с %1 установлено'"), ТипУчетнойЗаписи);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьВидСтраницыНастройки(Форма)

	ЭлементыФормы = Форма.Элементы;
	ТипУчетнойЗаписи = Форма.ТипУчетнойЗаписи;
	СтатусСинхронизации = Форма.СтатусСинхронизации;
	ЭлементКартинка = ЭлементыФормы.КартинкаСостояниеСинхронизации;
	ЭлементНадпись = ЭлементыФормы.НадписьСостояниеСинхронизации;
	ЭлементКнопкаПодключить = ЭлементыФормы.Подключить;
	ЭлементКнопкаОтключить = ЭлементыФормы.Отключить;
	ЭлементГруппа = ЭлементыФормы.ГруппаКнопкиУправленияСинхронизацией;
	ЭлементГруппа.Видимость = Истина;
	Форма.ТолькоПросмотр = Ложь;
	Если СтатусСинхронизации = СтатусыСинхронизации()["НастроенаПодключение"] Тогда
		ЭлементКартинка.Картинка = БиблиотекаКартинок.ДлительнаяОперация24;
		ЭлементНадпись.Заголовок = НСтр("ru = 'Выполняется подключение..'");
		ЭлементКнопкаПодключить.Видимость = Ложь;
		ЭлементКнопкаОтключить.Видимость = Ложь;
		ЭлементГруппа.Видимость = Ложь;
		Форма.ТолькоПросмотр = Истина;
	ИначеЕсли СтатусСинхронизации = СтатусыСинхронизации()["НастроенаПодключена"] Тогда
		ЭлементКартинка.Картинка = БиблиотекаКартинок.ЗеленаяГалка;
		ЭлементНадпись.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Синхронизация с %1 включена'"), ТипУчетнойЗаписи);
		ЭлементКнопкаПодключить.Видимость = Ложь;
		ЭлементКнопкаОтключить.Видимость = Истина;
	ИначеЕсли СтатусСинхронизации = СтатусыСинхронизации()["НастроенаОтключена"] Тогда
		ЭлементКартинка.Картинка = БиблиотекаКартинок.КрасныйКрест;
		ЭлементНадпись.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Синхронизация с %1 отключена'"), ТипУчетнойЗаписи);
		ЭлементКнопкаПодключить.Видимость = Истина;
		ЭлементКнопкаОтключить.Видимость = Ложь;
	ИначеЕсли СтатусСинхронизации = СтатусыСинхронизации()["НастроенаОшибка"] Тогда
		ЭлементКартинка.Картинка = БиблиотекаКартинок.КрасныйКрест;
		ЭлементНадпись.Заголовок = Форма.ТекущееОписаниеОшибки;
		ЭлементКнопкаПодключить.Видимость = Истина;
		ЭлементКнопкаОтключить.Видимость = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область Подключение

&НаКлиенте
Процедура ПодключитьНаКлиенте()

	ОбновитьВидимостьЭлементов(ЭтаФорма);
	Если СтатусСинхронизации = СтатусыСинхронизации()["НеНастроенаПодключение"] Тогда
		Если Не ПроверитьЗаполнение() Тогда
			СтатусСинхронизации = СтатусыСинхронизации()["НеНастроена"];
			Возврат;
		КонецЕсли;
	КонецЕсли;
	ДлительнаяОперация = ДлительнаяОперацияПодключения();
	Если ЗначениеЗаполнено(ДлительнаяОперация) Тогда
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗавершитьНаКлиентеПодключениеВФоне", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ДлительнаяОперацияПодключения()

	ДлительнаяОперация = Неопределено;
	ПараметрыПроцедуры = Новый Структура();
	ЗаполнитьПараметрыПроцедурыGoogle(ПараметрыПроцедуры);
	ЗаполнитьПараметрыПроцедурыiCloud(ПараметрыПроцедуры);
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.Вставить("НаименованиеФоновогоЗадания",
			НСтр("ru = 'Включение синхронизации с календарем'"));
	ПараметрыВыполненияВФоне.ОжидатьЗавершение = 0;
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
		"СинхронизацияКалендарей.ПолучитьСписокКалендарейВФоне",
		ПараметрыПроцедуры,
		ПараметрыВыполненияВФоне);
	Возврат ДлительнаяОперация;

КонецФункции

&НаСервере
Процедура ЗаполнитьПараметрыПроцедурыGoogle(ПараметрыПроцедуры)

	Если Не ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["Google"] Тогда
		Возврат;
	КонецЕсли;
	ПараметрыПроцедуры = Новый Структура();
	ПараметрыПроцедуры.Вставить("ТипСинхронизации", Перечисления.ТипыСинхронизацииКалендарей.Google);
	Если ЗначениеЗаполнено(ТокенДоступаGoogle) Тогда
		ПараметрыПроцедуры.Вставить("Узел", Узел);
	Иначе
		ПараметрыПроцедуры.Вставить("КодРазрешения", КодРазрешенияGoogle);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыПроцедурыiCloud(ПараметрыПроцедуры)

	Если Не ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["iCloud"] Тогда
		Возврат;
	КонецЕсли;
	ПараметрыПроцедуры.Вставить("ТипСинхронизации", Перечисления.ТипыСинхронизацииКалендарей.DAV);
	ПараметрыПроцедуры.Вставить("Сервер", СерверiCloud);
	ПараметрыПроцедуры.Вставить("Логин", ЛогинiCloud);
	Если ЗначениеЗаполнено(Узел) Тогда
		УстановитьПривилегированныйРежим(Истина);
		Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Узел, "Пароль");
		УстановитьПривилегированныйРежим(Ложь);
	Иначе
		Пароль = ПарольiCloud;
	КонецЕсли;
	ПараметрыПроцедуры.Вставить("Пароль", Пароль);

КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьНаКлиентеПодключениеВФоне(ДлительнаяОперация, ДополнительныеПараметры = Неопределено) Экспорт

	ЗавершитьПодключениеВФоне(ДлительнаяОперация);
	ОбновитьВидимостьЭлементов(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ЗавершитьПодключениеВФоне(ДлительнаяОперация)

	Если Не ЗначениеЗаполнено(ДлительнаяОперация) Тогда
		Возврат;
	КонецЕсли;
	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		Включен = Истина;
		Результат = ПолучитьИзВременногоХранилища(ДлительнаяОперация.АдресРезультата);
		Для Каждого Календарь Из Результат.СписокКалендарей Цикл
			НоваяСтрока = Календари.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Календарь);
			НоваяСтрока.ВидЗагрузки = ВидыЗагрузкиКалендарей()[НСтр("ru = 'Полностью'")];
			Элементы.КалендарьДляЗаписиПодключение.СписокВыбора.Добавить(Календарь.Идентификатор, Календарь.Наименование);
			Элементы.КалендарьДляЗаписиНастройка.СписокВыбора.Добавить(Календарь.Идентификатор, Календарь.Наименование);
			Если Не ЗначениеЗаполнено(КалендарьДляЗаписи) Тогда
				КалендарьДляЗаписи = Элементы.КалендарьДляЗаписиПодключение.СписокВыбора[0].Значение;
				НоваяСтрока.Изменение = Истина;
				НоваяСтрока.Чтение = Истина;
			КонецЕсли;
		КонецЦикла;
		Если ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["Google"] Тогда
			ТокенДоступаGoogle = Результат.ДанныеАвторизации.ТокенДоступа;
			ТипТокенаДоступаGoogle = Результат.ДанныеАвторизации.ТипТокенаДоступа;
			ТокенОбновленияGoogle = Результат.ДанныеАвторизации.ТокенОбновления;
		ИначеЕсли ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["iCloud"] Тогда
			КаталогКалендарейiCloud = Результат.КаталогКалендарей;
		КонецЕсли;
		Если ЗначениеЗаполнено(Узел) Тогда
			ЗаполнитьКалендариПользователя(Узел);
		КонецЕсли;
		Если СтатусСинхронизации = СтатусыСинхронизации()["НеНастроенаПодключение"] Тогда
			СтатусСинхронизации = СтатусыСинхронизации()["ПодключениеУстановлено"];
		ИначеЕсли СтатусСинхронизации = СтатусыСинхронизации()["НастроенаПодключение"] Тогда
			СтатусСинхронизации = СтатусыСинхронизации()["НастроенаПодключена"];
		КонецЕсли;
	Иначе
		Включен = Ложь;
		Если СтатусСинхронизации = СтатусыСинхронизации()["НеНастроенаПодключение"] Тогда
			СтатусСинхронизации = СтатусыСинхронизации()["НеНастроенаОшибка"];
		ИначеЕсли СтатусСинхронизации = СтатусыСинхронизации()["НастроенаПодключение"] Тогда
			СтатусСинхронизации = СтатусыСинхронизации()["НастроенаОшибка"];
		КонецЕсли;
		ТекущееОписаниеОшибки = НСтр(СтрШаблон("ru = 'При подключении произошла ошибка:
			|%1'", ДлительнаяОперация.КраткоеПредставлениеОшибки));
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКалендариПользователя(Узел)

	КалендарьДляЗаписи = "";
	СписокВыбора = Элементы.КалендарьДляЗаписиПодключение.СписокВыбора;
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	тзКалендари.Наименование КАК Наименование,
	|	тзКалендари.Идентификатор КАК Идентификатор
	|ПОМЕСТИТЬ тзКалендари
	|ИЗ
	|	&тзКалендари КАК тзКалендари
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	тзКалендари.Идентификатор КАК Идентификатор,
	|	тзКалендари.Наименование КАК Наименование,
	|	ЕСТЬNULL(СинхронизацияКалендарейКалендари.Чтение, ЛОЖЬ) КАК Чтение,
	|	ЕСТЬNULL(СинхронизацияКалендарейКалендари.Изменение, ЛОЖЬ) КАК Изменение,
	|	ЕСТЬNULL(СинхронизацияКалендарейКалендари.БезОписания, ЛОЖЬ) КАК БезОписания
	|ИЗ
	|	тзКалендари КАК тзКалендари
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланОбмена.СинхронизацияКалендарей.Календари КАК СинхронизацияКалендарейКалендари
	|		ПО (ПОДСТРОКА(тзКалендари.Идентификатор, 1, 1000) = ПОДСТРОКА(СинхронизацияКалендарейКалендари.Идентификатор, 1, 1000))
	|			И (СинхронизацияКалендарейКалендари.Ссылка = &Узел)");
	Запрос.УстановитьПараметр("тзКалендари", Календари.Выгрузить());
	Запрос.УстановитьПараметр("Узел", Узел);
	РезультатЗапроса = Запрос.Выполнить();
	СписокВыбора.Очистить();
	Календари.Очистить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			НоваяСтрока = Календари.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.ВидЗагрузки = ?(Выборка.БезОписания, НСтр("ru = 'Без описания'"), НСтр("ru = 'Полностью'"));
			СписокВыбора.Добавить(Выборка.Идентификатор, Выборка.Наименование);
			Если Выборка.Изменение Тогда
				КалендарьДляЗаписи = СписокВыбора[СписокВыбора.Количество() - 1].Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ЗаписьДанных

&НаСервере
Процедура ЗаписатьДанныеУчетнойЗаписи()

	УстановитьПривилегированныйРежим(Истина);
	Если Не ЗначениеЗаполнено(Узел) Тогда
		Узел = ПланыОбмена.СинхронизацияКалендарей.СсылкаНовогоУзла(
			Пользователи.ТекущийПользователь(), ТипСинхронизации(ТипУчетнойЗаписи));
		ЗаписатьНастройкиGoogle(Узел);
		ЗаписатьНастройкиiCloud(Узел);
	КонецЕсли;
	УзелОбъект = Узел.ПолучитьОбъект();
	УзелОбъект.ДатаПервоначальнойСинхронизации = ДатаСинхронизации;
	УзелОбъект.Включен = Включен;
	УзелОбъект.ВремяУведомленийЭкспорт = ?(ПолучатьУведомленияЭкспорт, ВремяУведомленийЭкспорт*60, 0);
	УзелОбъект.ВремяУведомленийИмпорт = ?(ПолучатьУведомленияИмпорт, ВремяУведомленийИмпорт*60, 0);
	УзелОбъект.Календари.Очистить();
	Для Каждого СтрокаКалендари Из Календари Цикл
		Если СтрокаКалендари.Чтение Или СтрокаКалендари.Изменение Тогда
			НоваяСтрока = УзелОбъект.Календари.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКалендари);
		КонецЕсли;
	КонецЦикла;
	УзелОбъект.Записать();
	Модифицированность = Ложь;

КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиiCloud(Узел)
	
	Если Не ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["iCloud"] Тогда
		Возврат;
	КонецЕсли;
	Данные = РегистрыСведений.НастройкиСинхронизацииDAV.НовыеДанныеАвторизации();
	Данные.Сервер = СерверiCloud;
	Данные.ИмяПользователя = ЛогинiCloud;
	Данные.Пароль = ПарольiCloud;
	Данные.КаталогКалендарей = КаталогКалендарейiCloud;
	РегистрыСведений.НастройкиСинхронизацииDAV.ЗаписатьДанныеАвторизации(Узел, Данные);
	ПарольiCloud = ?(ЗначениеЗаполнено(ПарольiCloud), ЭтотОбъект.УникальныйИдентификатор, "");
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройкиGoogle(Узел)

	Если Не ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["Google"] Тогда
		Возврат;
	КонецЕсли;
	ДанныеАвторизации = РегистрыСведений.НастройкиСинхронизацииGoogle.НовыеДанныеАвторизации();
	ДанныеАвторизации.ТокенДоступа = ТокенДоступаGoogle;
	ДанныеАвторизации.ТипТокенаДоступа = ТипТокенаДоступаGoogle;
	ДанныеАвторизации.ТокенОбновления = ТокенОбновленияGoogle;
	РегистрыСведений.НастройкиСинхронизацииGoogle.ЗаписатьДанныеАвторизации(Узел, ДанныеАвторизации);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ТипСинхронизации(ТипУчетнойЗаписи)

	ТипСинхронизации = Неопределено;
	Если ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["iCloud"] Тогда
		ТипСинхронизации = Перечисления.ТипыСинхронизацииКалендарей.DAV;
	ИначеЕсли ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["Google"] Тогда
		ТипСинхронизации = Перечисления.ТипыСинхронизацииКалендарей.Google;
	КонецЕсли;
	Возврат ТипСинхронизации;

КонецФункции

#КонецОбласти

#Область Синхронизация

&НаКлиенте
Процедура СинхронизироватьКалендариНаКлиенте()

	ДлительнаяОперация = ДлительнаяОперацияСинхронизации();
	Если ЗначениеЗаполнено(ДлительнаяОперация) Тогда
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
		ПараметрыОжидания.ОповещениеПользователя.Показать = Истина;
		ПараметрыОжидания.ОповещениеПользователя.Текст = НСтр("ru = 'Синхронизация завершена.'");
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗавершитьНаКлиентеСинхронизациюВФоне", ЭтотОбъект);
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ДлительнаяОперацияСинхронизации()

	ДлительнаяОперация = Неопределено;
	ТекПользователь = Пользователи.ТекущийПользователь();
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыПроцедуры = Новый Структура();
	ПараметрыПроцедуры.Вставить("Пользователь", ТекПользователь);
	Если ЗначениеЗаполнено(ДатаСинхронизации) Тогда
		ПараметрыПроцедуры.Вставить("ДатаНачала", ДатаСинхронизации);
		ПараметрыПроцедуры.Вставить("ДатаОкончания", ДобавитьМесяц(ТекущаяДатаСеанса(), 12));
	КонецЕсли;
	ПараметрыВыполненияВФоне.Вставить("НаименованиеФоновогоЗадания",
		СтрШаблон(НСтр("ru = 'Синхронизация календаря пользователя %1'"), ТекПользователь));
	ПараметрыВыполненияВФоне.ОжидатьЗавершение = 0;
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(
		"СинхронизацияКалендарей.СинхронизироватьВФоне",
		ПараметрыПроцедуры,
		ПараметрыВыполненияВФоне);
	Возврат ДлительнаяОперация;

КонецФункции

&НаКлиенте
Процедура ЗавершитьНаКлиентеСинхронизациюВФоне(ДлительнаяОперация, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ЗначениеЗаполнено(ДлительнаяОперация) Тогда
		Если ДлительнаяОперация.Статус = "Ошибка" Тогда
			ПоказатьОповещениеПользователя(ДлительнаяОперация.КраткоеПредставлениеОшибки,
				"e1cib/command/Справочник.ЗаписиРабочегоКалендаря.Команда.ОткрытьКалендарь",
				НСтр("ru = 'Мой календарь'"), БиблиотекаКартинок.Предупреждение32, СтатусОповещенияПользователя.Важное);
		КонецЕсли;
	КонецЕсли;
	ЗаполнитьДанныеПоследнейСинхронизации();
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПриИзмененииВидаЗагрузки(СтрокаТаблицы)

	Если СтрокаТаблицы.ВидЗагрузки = ВидыЗагрузкиКалендарей()[НСтр("ru = 'Полностью'")] Тогда
		СтрокаТаблицы.Чтение = Истина;
		СтрокаТаблицы.БезОписания = Ложь;
	ИначеЕсли СтрокаТаблицы.ВидЗагрузки = ВидыЗагрузкиКалендарей()[НСтр("ru = 'БезОписания'")] Тогда
		СтрокаТаблицы.Чтение = Истина;
		СтрокаТаблицы.БезОписания = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВопросаУдаление(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		УдалитьНаСервере();
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВопросаПередЗакрытием(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		Если ПроверитьЗаполнение() Тогда
			СохранитьНаСервере();
			Закрыть();
		КонецЕсли;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;	

КонецПроцедуры

&НаСервереБезКонтекста
Функция АдресЗапросаНаПодтверждениеДоступа()

	Возврат СинхронизацияGoogle.АдресЗапросаНаПодтверждениеДоступа();

КонецФункции

&НаСервере
Процедура СохранитьНаСервере()

	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	НачатьТранзакцию();
	Попытка
		ЗаписатьДанныеУчетнойЗаписи();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Произошла ошибка при записи данных.'") + Символы.ПС + ОписаниеОшибки());
		ВызватьИсключение;
	КонецПопытки;
	ЗарегистрироватьИзменения();

КонецПроцедуры

&НаСервере
Процедура ЗарегистрироватьИзменения()

	Если Не ЗначениеЗаполнено(ДатаСинхронизации) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗаписиРабочегоКалендаря.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ЗаписиРабочегоКалендаря КАК ЗаписиРабочегоКалендаря
	|ГДЕ
	|	НЕ ЗаписиРабочегоКалендаря.ПометкаУдаления
	|	И ЗаписиРабочегоКалендаря.Пользователь = &Пользователь
	|	И ЗаписиРабочегоКалендаря.ДатаНачала МЕЖДУ &ДатаНачала И &ДатаОкончания");
	Запрос.УстановитьПараметр("Пользователь", Узел.Пользователь);
	Запрос.УстановитьПараметр("ДатаНачала", ДатаСинхронизации);
	Запрос.УстановитьПараметр("ДатаОкончания", ДобавитьМесяц(ТекущаяДатаСеанса(), 12));
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			ПланыОбмена.ЗарегистрироватьИзменения(Узел, Выборка.Ссылка);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УдалитьНаСервере()

	НачатьТранзакцию();
	Попытка
		ПланыОбмена.СинхронизацияКалендарей.ОчиститьУзел(Узел);
		Если ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["iCloud"] Тогда
			РегистрыСведений.НастройкиСинхронизацииDAV.УдалитьДанныеАвторизации(Узел);
		ИначеЕсли ТипУчетнойЗаписи = ТипыУчетныхЗаписей()["Google"] Тогда
			РегистрыСведений.НастройкиСинхронизацииGoogle.УдалитьДанныеАвторизации(Узел);
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение НСтр("ru = 'Произошла ошибка при записи данных.'") + Символы.ПС + ОписаниеОшибки();
	КонецПопытки;

КонецПроцедуры

&НаСервере
Процедура ОтключитьНаСервере()

	Включен = Ложь;
	Если ЗначениеЗаполнено(Узел) Тогда
		УстановитьПривилегированныйРежим(Истина);
		УзелОбъект = Узел.ПолучитьОбъект();
		УзелОбъект.Включен = Включен;
		УзелОбъект.Записать();
	КонецЕсли;
	СтатусСинхронизации = СтатусыСинхронизации()["НастроенаОтключена"];

КонецПроцедуры

#КонецОбласти
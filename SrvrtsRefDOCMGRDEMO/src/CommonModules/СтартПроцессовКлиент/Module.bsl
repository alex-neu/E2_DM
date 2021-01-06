
////////////////////////////////////////////////////////////////////////////////
// Старт процессов клиент: в модуле содержатся процедуры для работы
// со стартом бизнес-процессов на клиенте.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс_КарточкаШаблонаПроцесса

// Заполняет срок отложенного старта в шаблоне процесса из реквизитов формы.
// Предназначена для вызова из обработчика формы ПередЗаписью.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - карточка шаблона процесса.
//
Процедура КарточкаШаблонаПередЗаписью(Форма) Экспорт
	
	Форма.Объект.СрокОтложенногоСтарта = 
		Форма.ОтложенныйСтартЧасы * 3600 + Форма.ОтложенныйСтартДни * 86400;
	
КонецПроцедуры

// Обработчик Нажатие ссылки для настройки отложенного старта в карточках шаблонов процессов.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - карточка шаблона процесса.
//  СтандартнаяОбработка - Булево - признак стандартной обработки начала выбора.
//
Процедура ОписаниеОтложенногоСтартаНажатие(Форма, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Форма", Форма);
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОписаниеОтложенногоСтартаНажатиеПродолжение",
		ЭтотОбъект,
		ПараметрыОповещения);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Настройка отложенного старта'"));
	ПараметрыФормы.Вставить("Дни", Форма.ОтложенныйСтартДни);
	ПараметрыФормы.Вставить("Часы", Форма.ОтложенныйСтартЧасы);
	
	ОткрытьФорму(
		"ОбщаяФорма.НастройкаКоличестваДнейИЧасов",
		ПараметрыФормы,
		Форма,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Продолжение процедуры ОписаниеОтложенногоСтартаНажатие.
Процедура ОписаниеОтложенногоСтартаНажатиеПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = Параметры.Форма;
	
	Форма.ОтложенныйСтартДни = Результат.Дни;
	Форма.ОтложенныйСтартЧасы = Результат.Часы;
	
	Форма.ОписаниеОтложенногоСтарта = СтартПроцессовКлиентСервер.УстановитьОписанияОтложенногоСтарта(
		Форма.ОтложенныйСтартДни, Форма.ОтложенныйСтартЧасы);
		
	Форма.ОбновитьСрокиИсполненияОтложенно("ОписаниеОтложенногоСтарта");
	
КонецПроцедуры

#КонецОбласти

#Область ПрограммныйИнтерфейс_КарточкаПроцесса

// Открыват форму выбора даты отложенного старта для карточки процесса.
//
// Параметры:
//  Форма - ФормаКлиентскогоПриложения - карточка процесса.
//
Процедура УстановитьДатуОтложенногоСтарта(Форма) Экспорт
	
	Параметры = Новый Структура;
	
	Если ЗначениеЗаполнено(Форма.НастройкаСтарта) Тогда
		Параметры.Вставить("ДатаОтложенногоСтарта", Форма.НастройкаСтарта.ДатаОтложенногоСтарта);
	Иначе
		Параметры.Вставить("ДатаОтложенногоСтарта", НачалоДня(ТекущаяДата()) + 86400);
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершениеУстановкиДатыОтложенногоСтарта", ЭтотОбъект, Форма);
	
	ОткрытьФорму("РегистрСведений.ПроцессыДляЗапуска.Форма.ВыборДатыОтложенногоСтарта",
		Параметры,
		Форма,,,,ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

// Продолжение процедуры УстановитьДатуОтложенногоСтарта
Процедура ЗавершениеУстановкиДатыОтложенногоСтарта(ДатаОтложенногоСтарта, Форма) Экспорт
	
	Если ДатаОтложенногоСтарта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма.ЗаблокироватьДанныеФормыДляРедактирования();
	Форма.Модифицированность = Истина;
	
	Если Не ЗначениеЗаполнено(Форма.НастройкаСтарта) Тогда
		Форма.НастройкаСтарта = СтартПроцессовКлиентСервер.СтруктураНастройкиСтартаПроцессов();
	КонецЕсли;
	
	Форма.НастройкаСтарта.ДатаОтложенногоСтарта = ДатаОтложенногоСтарта;
	Форма.НастройкаСтарта.Состояние = 
		ПредопределенноеЗначение("Перечисление.СостоянияПроцессовДляЗапуска.ПустаяСсылка");
	
	Форма.ОбновитьФормуПослеИзмененияНастроекОтложенногоСтарта();
	
КонецПроцедуры

// Обработчик ссылки описания состояния отложенного старта в карточке процесса.
//
// Параметры:
//  НавигационнаяСсылкаФорматированнойСтроки - Ссылка описания состояния отложенного старта.
//  Форма - ФормаКлиентскогоПриложения - карточка процесса.
//
Процедура ДекорацияОписаниеОбработкаНавигационнойСсылки(
	НавигационнаяСсылкаФорматированнойСтроки, Форма) Экспорт
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ВыбратьДатуОтложенногоСтарта" Тогда
		УстановитьДатуОтложенногоСтарта(Форма);
	КонецЕсли;
		
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОчиститьДатуОтложенногоСтарта"
		И ЗначениеЗаполнено(Форма.НастройкаСтарта) Тогда
		
		Форма.НастройкаСтарта.ДатаОтложенногоСтарта = Дата(1,1,1);
		Форма.ОбновитьФормуПослеИзмененияНастроекОтложенногоСтарта();
		Форма.Модифицированность = Истина;
	КонецЕсли;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "УдалитьНастройкуОтложенногоСтарта" Тогда
		СтартПроцессовВызовСервера.УдалитьПроцессИзОчередиДляЗапуска(Форма.Объект.Ссылка);
		Форма.НастройкаСтарта = Неопределено;
		Форма.ОбновитьФормуПослеИзмененияНастроекОтложенногоСтарта();
		Оповестить("БизнесПроцессИзменен", Форма.Объект.Ссылка, Форма);
	КонецЕсли;
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьОписаниеОшибкиОтложенногоСтарта" Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Заголовок", НСтр("ru = 'Ошибка'"));
		ПараметрыФормы.Вставить("ТекстСообщения", Форма.НастройкаСтарта.ПричинаОтменыСтарта);
		ОткрытьФорму("ОбщаяФорма.Сообщение", ПараметрыФормы, Форма);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

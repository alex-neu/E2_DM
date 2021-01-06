///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив Из Строка -
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("Служебный");
	НеРедактируемыеРеквизиты.Добавить("ИдентификаторПользователяИБ");
	НеРедактируемыеРеквизиты.Добавить("ИдентификаторПользователяСервиса");
	НеРедактируемыеРеквизиты.Добавить("СвойстваПользователяИБ");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульСозданиеНаОсновании = ОбщегоНазначения.ОбщийМодуль("СозданиеНаОсновании");
		Возврат МодульСозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Справочники.Пользователи);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	
КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

// Возвращает состав пользователей, входящих в указанный контейнер.
//
// Параметры:
//   Контейнер - СправочникСсылка.Пользователи - контейнер пользователей.
//
// Возвращаемое значение:
//   Массив - массив значений СправочникСсылка.Пользователи - состав контейнера.
//
Функция СоставКонтейнераПользователей(Контейнер) Экспорт
	
	Результат = Новый Массив;
	ПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контейнер, "ПометкаУдаления");
	Если ПометкаУдаления <> Истина Тогда
		Результат.Добавить(Контейнер);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает состав контейнеров типа Пользователи, которым принадлежит указанный пользователь.
//
// Параметры:
//   Пользователь - СправочникСсылка.Пользователи - проверяемый пользователь.
//
// Возвращаемое значение:
//   Массив - массив значений СправочникСсылка.Пользователи - контейнеры, которым принадлежит пользователь.
//
Функция КонтейнерыПользователя(Пользователь) Экспорт
	
	Результат = Новый Массив;
	ПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ПометкаУдаления");
	Если ПометкаУдаления <> Истина Тогда
		Результат.Добавить(Пользователь);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

КонецПроцедуры

// Вернет Истина, у этого объекта метаданных есть функция ПолучитьАдресФото
Функция ЕстьФункцияПолученияФото() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Прочитать фото и вернуть адрес (навигационную ссылку)
// Параметры:
//  Ссылка - ссылка на справочник, для которого надо показать фото
//  УникальныйИдентификатор - уникальный идентификатор формы, откуда идет вызов
//  ЕстьКартинка - возвращаемое значение - Булево - Истина, если в объекте есть картинка
//
// Возвращаемое значение:
//   Строка - навигационная ссылка - или "", если нет картинки
Функция ПолучитьАдресФото(Ссылка, УникальныйИдентификатор, ЕстьКартинка) Экспорт
	
	АдресКартинки = "";
	
	КонтейнерФотографии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ФизЛицо");
	Если Не ЗначениеЗаполнено(КонтейнерФотографии) Тогда
		КонтейнерФотографии = Справочники.КаналыОбсуждений.КаналПоПользователю(Ссылка);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КонтейнерФотографии) Тогда
		Возврат АдресКартинки;
	КонецЕсли;
	
	Если УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей() 
		И Не ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(КонтейнерФотографии).Чтение Тогда
		Возврат АдресКартинки;
	КонецЕсли;
	
	АдресКартинки = РаботаСФотографиями.ПолучитьНавигационнуюСсылкуРеквизита(
		КонтейнерФотографии, УникальныйИдентификатор, ЕстьКартинка);
	
	Возврат АдресКартинки;
	
КонецФункции

// Возвращает двоичные данные фото пользователя
//
Функция ПолучитьДвоичныеДанныеФото(Пользователь) Экспорт
	
	КонтейнерФотографии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ФизЛицо");
	
	Если Не ЗначениеЗаполнено(КонтейнерФотографии) Тогда
		КонтейнерФотографии = Справочники.КаналыОбсуждений.КаналПоПользователю(Пользователь);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КонтейнерФотографии) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей()
		И Не ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(КонтейнерФотографии).Чтение Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДвоичныеДанные = РаботаСФотографиями.ПолучитьДвоичныеДанныеРеквизита(
		КонтейнерФотографии, "ФайлФотографии");
	Если Не ЗначениеЗаполнено(ДвоичныеДанные) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ДвоичныеДанные;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если РольДоступна("ПолныеПрава") Тогда
			ВыбраннаяФорма = "ФормаЭлемента";
		Иначе
			ВыбраннаяФорма = "ФормаПользователя";
		КонецЕсли;
		
	ИначеЕсли ВидФормы = "ФормаВыбора"
		Или (ВидФормы = "ФормаСписка"
			И Параметры.Свойство("РежимВыбора")
			И Параметры.РежимВыбора) Тогда
			
		СтандартнаяОбработка = Ложь;
		
		ВыбраннаяФорма = "Справочник.АдреснаяКнига.ФормаСписка";
		
		Параметры.Вставить("РежимРаботыФормы", 1);
		Параметры.Вставить("УпрощенныйИнтерфейс", Истина);
		Параметры.Вставить("ОтображатьСотрудников", Истина);
		Параметры.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор пользователя'"));
		
		Если Параметры.Свойство("ВыборГруппПользователей")
			И Параметры.ВыборГруппПользователей = Истина Тогда
			Параметры.Вставить("ВыбиратьКонтейнерыПользователей", Истина);
		КонецЕсли;
		
		Если Параметры.Свойство("ТекущаяСтрока") Тогда
			Параметры.Вставить("ВыбранныеАдресаты", Параметры.ТекущаяСтрока);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Недействителен = Ложь;
	Служебный = Ложь;
	
	Если Параметры.Отбор.Свойство("Недействителен") Тогда
		Недействителен = Параметры.Отбор.Недействителен;
	Иначе
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Служебный") Тогда
		Служебный = Параметры.Отбор.Служебный;
	Иначе
		Параметры.Отбор.Вставить("Служебный", Ложь);
	КонецЕсли;
	
	Текст = Параметры.СтрокаПоиска; 
	СловаПоиска = ОбщегоНазначенияДокументооборот.СловаПоиска(Текст);
	ДанныеВыбора = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Пользователи.Ссылка КАК Ссылка,
	|	СведенияОПользователяхДокументооборот.Подразделение КАК Подразделение,
	|	СведенияОПользователяхДокументооборот.Должность КАК Должность
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОПользователяхДокументооборот КАК СведенияОПользователяхДокументооборот
	|		ПО Пользователи.Ссылка = СведенияОПользователяхДокументооборот.Пользователь
	|ГДЕ
	|	Пользователи.Наименование ПОДОБНО &Текст
	|	И Пользователи.Недействителен = &Недействителен
	|	И Пользователи.Служебный = &Служебный";
	
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	Запрос.УстановитьПараметр("Недействителен", Недействителен);
	Запрос.УстановитьПараметр("Служебный", Служебный);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ПредставлениеФорматированнаяСтрока = ОбщегоНазначенияДокументооборот.ФорматированныйРезультатПоиска(
			Строка(Выборка.Ссылка),
			СловаПоиска);
		Если ЗначениеЗаполнено(Выборка.Подразделение) Или ЗначениеЗаполнено(Выборка.Должность) Тогда 
			
			ДобавкаТекст = "";
			Если ЗначениеЗаполнено(Выборка.Подразделение) И ЗначениеЗаполнено(Выборка.Должность) Тогда 
				ДобавкаТекст = СтрШаблон(НСтр("ru = ' (%1, %2)'"), Строка(Выборка.Подразделение), Строка(Выборка.Должность));
			ИначеЕсли ЗначениеЗаполнено(Выборка.Подразделение) Тогда 	
				ДобавкаТекст = СтрШаблон(НСтр("ru = ' (%1)'"), Строка(Выборка.Подразделение));
			ИначеЕсли ЗначениеЗаполнено(Выборка.Должность) Тогда 	
				ДобавкаТекст = СтрШаблон(НСтр("ru = ' (%1)'"), Строка(Выборка.Должность));
			КонецЕсли;	
			
			ПредставлениеФорматированнаяСтрока = Новый ФорматированнаяСтрока(
				ПредставлениеФорматированнаяСтрока, 
				Новый ФорматированнаяСтрока(ДобавкаТекст, 
					, WebЦвета.Серый)
				);
				
			ДанныеВыбора.Добавить(Выборка.Ссылка, ПредставлениеФорматированнаяСтрока);
			
		Иначе	
			
			ДанныеВыбора.Добавить(Выборка.Ссылка, ПредставлениеФорматированнаяСтрока);
			
		КонецЕсли;	
		
	КонецЦикла;	
	
	
КонецПроцедуры

#КонецОбласти

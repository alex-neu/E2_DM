#Область ОписаниеПеременных

&НаКлиенте
Перем ДеревоПроцессовРазвернутыеЭлементы;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Срок.
	СрокДней = ЭскалацияЗадачКлиентСервер.ЧислоДнейСрока(Объект.Срок);
	СрокЧасов = ЭскалацияЗадачКлиентСервер.ЧислоЧасовСрока(Объект.Срок);
	СтароеСрокЧасов = СрокЧасов;
	
	ИнициализироватьДеревоПроцессов(
		"ДеревоПроцессов",
		Объект.Процессы,
		КоличествоПроцессов);
	
	СписокОтбораАвтоподстановок.ЗагрузитьЗначения(ЭскалацияЗадач.ДоступныеАвтоподстановки());
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьСтраницыДействие();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.Срок = СрокДней * 86400 + СрокЧасов * 3600;
	
	ПеренестиПроцессыВТабличнуюЧасть(ТекущийОбъект.Процессы, "ДеревоПроцессов");
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.ВариантСрока <> Перечисления.ВариантыСрокаПравилЭскалацииЗадач.ЗадачаПросрочена
		И СрокДней = 0 И СрокЧасов = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Поле ""Срок"" не заполнено'"),,"СрокДней",,Отказ);
	КонецЕсли;
	Если КоличествоПроцессов = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указано для каких процессов сработает правило эскалации'"),,"ДеревоПроцессов",,Отказ);
	КонецЕсли;
	
	ИсключаемыеРеквизиты = Новый Массив;
	Если Объект.Действие <> Перечисления.ДействияПравилЭскалацииЗадач.Перенаправление Тогда
		ИсключаемыеРеквизиты.Добавить("НаправлениеЭскалации");
	КонецЕсли;
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, ИсключаемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура УсловиеСрокЧасовПриИзменении(Элемент)
	
	Если СрокЧасов > 23 Тогда
		СрокЧасов = СтароеСрокЧасов;
	Иначе
		СтароеСрокЧасов = СрокЧасов;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор ответственного'"));
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ЗавершениеВыбораОтветственного", ЭтотОбъект);
	
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыФормы, ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеВыбораОтветственного(ВыбранныеПользователи, ДопПараметры) Экспорт
	
	Если ВыбранныеПользователи = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Ответственный = ВыбранныеПользователи[0].Контакт;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДействиеПриИзменении(Элемент)
	
	УстановитьСтраницыДействие();
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеЭскалацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокПредметов = Новый СписокЗначений;
	СписокПредметов.Добавить("ОсновнойПредмет");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
	ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
	ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
	ПараметрыФормы.Вставить("ОтображатьАвтоподстановкиПоПроцессам", Истина);
	ПараметрыФормы.Вставить("СписокОтбораАвтоподстановок", СписокОтбораАвтоподстановок);
	ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор направления эскалации'"));
	ПараметрыФормы.Вставить("ИменаПредметов", СписокПредметов);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершениеВыбораНаправленияЭскалации", ЭтаФорма);
	РаботаСАдреснойКнигойКлиент.ВыбратьАдресатов(ПараметрыФормы, ЭтаФорма, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершениеВыбораНаправленияЭскалации(ВыбранныеУчастники, ДопПараметры) Экспорт
	
	Если ВыбранныеУчастники = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НаправлениеЭскалацииОбработкаВыбора(Элементы.НаправлениеЭскалации, ВыбранныеУчастники[0], Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеЭскалацииОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Объект.НаправлениеЭскалации = Неопределено
		Или ТипЗнч(Объект.НаправлениеЭскалации) = Тип("Строка") Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, Объект.НаправлениеЭскалации);
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеЭскалацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = "КонкретныйПользовательИлиРоль" Тогда
		СтандартнаяОбработка = Ложь;
		НаправлениеЭскалацииНачалоВыбора(Элемент, Неопределено, Ложь);
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		СтандартнаяОбработка = Ложь;
		Объект.НаправлениеЭскалации = ВыбранноеЗначение.Контакт;
		Если ТипЗнч(Объект.НаправлениеЭскалации) = Тип("Строка") Тогда
			Объект.НаправлениеЭскалации = СтрЗаменить(Объект.НаправлениеЭскалации, "ОсновнойПредмет.", "");
		КонецЕсли;
		
	Иначе
		Объект.НаправлениеЭскалации = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеЭскалацииАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		СтандартнаяОбработка = Ложь;
		Текст = СокрЛП(Текст);
		
		ДанныеВыбора =
			ЭскалацияЗадачВызовСервера.ДанныеВыбораНаправленияЭскалации(ПараметрыПолученияДанных);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаправлениеЭскалацииОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Текст) Тогда
		
		СтандартнаяОбработка = Ложь;
		Текст = СокрЛП(Текст);
		
		ДанныеВыбора =
			ЭскалацияЗадачВызовСервера.ДанныеВыбораНаправленияЭскалации(ПараметрыПолученияДанных);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоПроцессов

&НаКлиенте
Процедура ДеревоПроцессовПриИзменении(Элемент)
	
	ДеревоПроцессовПриИзмененииОбработка(Элемент, ДеревоПроцессов, КоличествоПроцессов);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПроцессовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ДеревоПроцессовВыборОбработка(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДополнительныеУсловия

&НаКлиенте
Процедура ДополнительныеУсловияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДополнительныеУсловия.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УсловияПриИзменении(ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеУсловияЗначениеУсловияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДополнительныеУсловия.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УсловияЗначениеУсловияНачалоВыбора(ТекущиеДанные, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеУсловияЗначениеУсловияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДополнительныеУсловия.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УсловияЗначениеУсловияОбработкаВыбора(ТекущиеДанные, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеУсловияЗначениеУсловияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ДополнительныеУсловия.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УсловияЗначениеУсловияАвтоПодбор(ТекущиеДанные, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьПроцесс(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьПроцессЗавершение", ЭтотОбъект);
	ЭскалацияЗадачКлиент.ВыбратьПроцесс(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьСтраницыДействие()
	
	Элементы.НаправлениеЭскалации.Видимость =
		(Объект.Действие = ПредопределенноеЗначение("Перечисление.ДействияПравилЭскалацииЗадач.Перенаправление"));
	Элементы.ВариантВыполнения.Видимость =
		(Объект.Действие = ПредопределенноеЗначение("Перечисление.ДействияПравилЭскалацииЗадач.АвтоматическоеВыполнение"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьЗначениеУсловия(ТекущиеДанные)
	
	Если ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.АвторЯвляется") Тогда
		ТекущиеДанные.ЗначениеУсловия = ПредопределенноеЗначение("Перечисление.ВариантыАвторЯвляетсяПравилЭскалацииЗадач.ПустаяСсылка");
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.ВажностьЗадачи") Тогда
		ТекущиеДанные.ЗначениеУсловия = ПредопределенноеЗначение("Перечисление.ВариантыВажностиЗадачи.ПустаяСсылка");
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.Исполнитель") Тогда
		ТекущиеДанные.ЗначениеУсловия = ПредопределенноеЗначение("Справочник.Пользователи.ПустаяСсылка");
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.ИсполнительВходитВРабочуюГруппу") Тогда
		ТекущиеДанные.ЗначениеУсловия = ПредопределенноеЗначение("Справочник.РабочиеГруппы.ПустаяСсылка");
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.ИсполнительВходитВПодразделение") Тогда
		ТекущиеДанные.ЗначениеУсловия = ПредопределенноеЗначение("Справочник.СтруктураПредприятия.ПустаяСсылка");
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.ИсполнительОтсутствует") Тогда
		ТекущиеДанные.ЗначениеУсловия = Истина;
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.ПринятаКИсполнению") Тогда
		ТекущиеДанные.ЗначениеУсловия = Истина;
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.Проект") Тогда
		ТекущиеДанные.ЗначениеУсловия = ПредопределенноеЗначение("Справочник.Проекты.ПустаяСсылка");
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.Произвольное") Тогда
		ТекущиеДанные.ЗначениеУсловия = ПредопределенноеЗначение("Справочник.УсловияЗадач.ПустаяСсылка");
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.УсловиеМаршрутизации") Тогда
		ТекущиеДанные.ЗначениеУсловия = ПредопределенноеЗначение("Справочник.УсловияМаршрутизации.ПустаяСсылка");
	Иначе
		ТекущиеДанные.ЗначениеУсловия = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияПриИзменении(ТекущиеДанные)
	
	Если ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.АвторЯвляется") Тогда
		Если ТипЗнч(ТекущиеДанные.ЗначениеУсловия) <> Тип("ПеречислениеСсылка.ВариантыАвторЯвляетсяПравилЭскалацииЗадач") Тогда
			ОчиститьЗначениеУсловия(ТекущиеДанные);
		КонецЕсли;
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.ВажностьЗадачи") Тогда
		Если ТипЗнч(ТекущиеДанные.ЗначениеУсловия) <> Тип("ПеречислениеСсылка.ВариантыВажностиЗадачи") Тогда
			ОчиститьЗначениеУсловия(ТекущиеДанные);
		КонецЕсли;
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.Исполнитель") Тогда
		Если ТипЗнч(ТекущиеДанные.ЗначениеУсловия) <> Тип("СправочникСсылка.Пользователи")
			И ТипЗнч(ТекущиеДанные.ЗначениеУсловия) <> Тип("СправочникСсылка.РолиИсполнителей") Тогда
			ОчиститьЗначениеУсловия(ТекущиеДанные);
		КонецЕсли;
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.ИсполнительВходитВРабочуюГруппу") Тогда
		Если ТипЗнч(ТекущиеДанные.ЗначениеУсловия) <> Тип("СправочникСсылка.РабочиеГруппы") Тогда
			ОчиститьЗначениеУсловия(ТекущиеДанные);
		КонецЕсли;
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.ИсполнительВходитВПодразделение") Тогда
		Если ТипЗнч(ТекущиеДанные.ЗначениеУсловия) <> Тип("СправочникСсылка.СтруктураПредприятия") Тогда
			ОчиститьЗначениеУсловия(ТекущиеДанные);
		КонецЕсли;
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.ИсполнительОтсутствует") Тогда
		Если ТипЗнч(ТекущиеДанные.ЗначениеУсловия) <> Тип("Булево") Тогда
			ОчиститьЗначениеУсловия(ТекущиеДанные);
		КонецЕсли;
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.ПринятаКИсполнению") Тогда
		Если ТипЗнч(ТекущиеДанные.ЗначениеУсловия) <> Тип("Булево") Тогда
			ОчиститьЗначениеУсловия(ТекущиеДанные);
		КонецЕсли;
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.Проект") Тогда
		Если ТипЗнч(ТекущиеДанные.ЗначениеУсловия) <> Тип("СправочникСсылка.Проекты") Тогда
			ОчиститьЗначениеУсловия(ТекущиеДанные);
		КонецЕсли;
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.Произвольное") Тогда
		Если ТипЗнч(ТекущиеДанные.ЗначениеУсловия) <> Тип("СправочникСсылка.УсловияЗадач") Тогда
			ОчиститьЗначениеУсловия(ТекущиеДанные);
		КонецЕсли;
	ИначеЕсли ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.УсловиеМаршрутизации") Тогда
		Если ТипЗнч(ТекущиеДанные.ЗначениеУсловия) <> Тип("СправочникСсылка.УсловияМаршрутизации") Тогда
			ОчиститьЗначениеУсловия(ТекущиеДанные);
		КонецЕсли;
	Иначе
		ОчиститьЗначениеУсловия(ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияЗначениеУсловияНачалоВыбора(ТекущиеДанные, Элемент, СтандартнаяОбработка)
	
	Если ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.Исполнитель") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ПараметрыФормы.Вставить("РежимРаботыФормы", 1);
		ПараметрыФормы.Вставить("ОтображатьСотрудников", Истина);
		ПараметрыФормы.Вставить("ОтображатьРоли", Истина);
		ПараметрыФормы.Вставить("ЗаголовокФормы", НСтр("ru = 'Выбор исполнителя'"));
		ОткрытьФорму("Справочник.АдреснаяКнига.ФормаСписка",
			ПараметрыФормы,
			Элемент,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияЗначениеУсловияОбработкаВыбора(ТекущиеДанные, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.Исполнитель") Тогда
		Если ТипЗнч(ВыбранноеЗначение) = Тип("Массив")
			И ВыбранноеЗначение.Количество() <> 0 
			И ТипЗнч(ВыбранноеЗначение[0]) = Тип("Структура")
			И ВыбранноеЗначение[0].Свойство("Контакт") Тогда
			
			СтандартнаяОбработка = Ложь;
			ТекущиеДанные.ЗначениеУсловия = ВыбранноеЗначение[0].Контакт;
			
		ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Пользователи")
			Или ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.ПолныеРоли") Тогда
			
			СтандартнаяОбработка = Ложь;
			ТекущиеДанные.ЗначениеУсловия = ВыбранноеЗначение;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УсловияЗначениеУсловияАвтоПодбор(ТекущиеДанные, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ТекущиеДанные.Условие = ПредопределенноеЗначение("Перечисление.УсловияПравилЭскалацииЗадач.Исполнитель") 
		И ЗначениеЗаполнено(Текст) Тогда 
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = ЭскалацияЗадачВызовСервера.СформироватьДанныеВыбораИсполнителя(Текст);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОтметитьПроцесс(
	ЗначениеДеревоПроцессов,
	ТипПроцесса,
	Шаблон,
	ТочкаМаршрута,
	ШаблонКомплексногоПроцесса)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ТипПроцесса", ТипПроцесса);
	ПараметрыОтбора.Вставить("Шаблон", Шаблон);
	ПараметрыОтбора.Вставить("ТочкаМаршрута", ТочкаМаршрута);
	НайденныеСтроки = ЗначениеДеревоПроцессов.Строки.НайтиСтроки(ПараметрыОтбора, Истина);
	Если НайденныеСтроки.Количество() = 0 Тогда
		
		Если ЗначениеЗаполнено(ШаблонКомплексногоПроцесса) Тогда
			СтрокаТипПроцесса = СтрокаТипПроцесса(
				ЗначениеДеревоПроцессов,
				Перечисления.ТипыПроцессовЭскалацииЗадач.КомплексныйПроцесс);
			ДобавитьСтроку(СтрокаТипПроцесса, "Шаблон", , ШаблонКомплексногоПроцесса);
		ИначеЕсли Не ЗначениеЗаполнено(Шаблон) Тогда
			СтрокаТипПроцесса = СтрокаТипПроцесса(ЗначениеДеревоПроцессов, ТипПроцесса);
			ДобавитьСтроку(СтрокаТипПроцесса, "БезШаблона", ТипПроцесса);
			
		Иначе
			СтрокаТипПроцесса = СтрокаТипПроцесса(ЗначениеДеревоПроцессов, ТипПроцесса);
			ДобавитьСтроку(СтрокаТипПроцесса, "Шаблон", , Шаблон);
			
		КонецЕсли;
		
		НайденныеСтроки = ЗначениеДеревоПроцессов.Строки.НайтиСтроки(ПараметрыОтбора, Истина);
		
	КонецЕсли;
	
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		НайденнаяСтрока.Пометка = 1;
	КонецЦикла;
	
КонецФункции

&НаСервере
Функция ДобавитьШаблонВДеревоПроцессов(ИмяРеквизита, Количество, Шаблон)
	
	ЗначениеДеревоПроцессов = РеквизитФормыВЗначение(ИмяРеквизита);
	
	ТипПроцесса = Перечисления.ТипыПроцессовЭскалацииЗадач.ТипПроцессаПоШаблону(Шаблон);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ТипПроцесса", ТипПроцесса);
	ПараметрыОтбора.Вставить("Шаблон", Шаблон);
	ПараметрыОтбора.Вставить("НазначениеСтроки", "Шаблон");
	НайденныеСтроки = ЗначениеДеревоПроцессов.Строки.НайтиСтроки(ПараметрыОтбора, Истина);
	Если НайденныеСтроки.Количество() = 0 Тогда
		СтрокаТипПроцесса = СтрокаТипПроцесса(ЗначениеДеревоПроцессов, ТипПроцесса);
		ДобавитьСтроку(СтрокаТипПроцесса, "Шаблон", , Шаблон);
		НайденныеСтроки = ЗначениеДеревоПроцессов.Строки.НайтиСтроки(ПараметрыОтбора, Истина);
	КонецЕсли;
	
	ЭлементыКОбработке = Новый Массив;
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		ЭлементыКОбработке.Добавить(НайденнаяСтрока);
	КонецЦикла;
	Пока ЭлементыКОбработке.Количество() <> 0 Цикл
		
		ЭлементКОбработке = ЭлементыКОбработке[0];
		ЭлементыКОбработке.Удалить(0);
		Для Каждого Элемент Из ЭлементКОбработке.Строки Цикл
			
			Если Элемент.НазначениеСтроки <> "ТочкаМаршрута" Тогда
				ЭлементыКОбработке.Добавить(Элемент);
				Продолжить;
			КонецЕсли;
			
			ТочкиМаршрута = Перечисления.ТипыПроцессовЭскалацииЗадач.ТочкиМаршрутаПоТипуПроцесса(
				Элемент.ТипПроцесса,
				Истина);
			Если ТочкиМаршрута.Найти(Элемент.ТочкаМаршрута) <> Неопределено Тогда
				Элемент.Пометка = 1;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ЗначениеДеревоПроцессов, ИмяРеквизита);
	
	ОбновитьЗначениеПометокДеревоПроцессов(ЭтаФорма[ИмяРеквизита], Количество);
	
	Возврат ИдентификаторСтрокиШаблона(ЭтаФорма[ИмяРеквизита], Шаблон);
	
КонецФункции

&НаСервере
Функция ДобавитьБезШаблонВДеревоПроцессов(ИмяРеквизита, Количество, ТипПроцесса)
	
	ЗначениеДеревоПроцессов = РеквизитФормыВЗначение(ИмяРеквизита);
	
	ДанныеШаблона = Перечисления.ТипыПроцессовЭскалацииЗадач.ДанныеШаблона(ТипПроцесса);
	Шаблон = ДанныеШаблона.ПустаяСсылка;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ТипПроцесса", ТипПроцесса);
	ПараметрыОтбора.Вставить("Шаблон", ДанныеШаблона.ПустаяСсылка);
	ПараметрыОтбора.Вставить("НазначениеСтроки", "БезШаблона");
	НайденныеСтроки = ЗначениеДеревоПроцессов.Строки.НайтиСтроки(ПараметрыОтбора, Истина);
	Если НайденныеСтроки.Количество() = 0 Тогда
		СтрокаТипПроцесса = СтрокаТипПроцесса(ЗначениеДеревоПроцессов, ТипПроцесса);
		ДобавитьСтроку(СтрокаТипПроцесса, "БезШаблона", ТипПроцесса);
		НайденныеСтроки = ЗначениеДеревоПроцессов.Строки.НайтиСтроки(ПараметрыОтбора, Истина);
	КонецЕсли;
	
	ЭлементыКОбработке = Новый Массив;
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		ЭлементыКОбработке.Добавить(НайденнаяСтрока);
	КонецЦикла;
	Пока ЭлементыКОбработке.Количество() <> 0 Цикл
		
		ЭлементКОбработке = ЭлементыКОбработке[0];
		ЭлементыКОбработке.Удалить(0);
		Для Каждого Элемент Из ЭлементКОбработке.Строки Цикл
			
			Если Элемент.НазначениеСтроки <> "ТочкаМаршрута" Тогда
				ЭлементыКОбработке.Добавить(Элемент);
				Продолжить;
			КонецЕсли;
			
			ТочкиМаршрута = Перечисления.ТипыПроцессовЭскалацииЗадач.ТочкиМаршрутаПоТипуПроцесса(
				Элемент.ТипПроцесса,
				Истина);
			Если ТочкиМаршрута.Найти(Элемент.ТочкаМаршрута) <> Неопределено Тогда
				Элемент.Пометка = 1;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ЗначениеДеревоПроцессов, ИмяРеквизита);
	
	ОбновитьЗначениеПометокДеревоПроцессов(ЭтаФорма[ИмяРеквизита], Количество);
	
	Возврат ИдентификаторСтрокиШаблона(ЭтаФорма[ИмяРеквизита], Шаблон);
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПодчиненныеЭлементы(Строка)
	
	Если Строка.НазначениеСтроки = "БезШаблона"
		Или (СтрНачинаетсяС(Строка.НазначениеСтроки, "Шаблон")
			И Перечисления.ТипыПроцессовЭскалацииЗадач.ЭтоОбычныйПроцесс(Строка.ТипПроцесса)) Тогда
		
		ТочкиМаршрута = Перечисления.ТипыПроцессовЭскалацииЗадач.ТочкиМаршрутаПоТипуПроцесса(
			Строка.ТипПроцесса,
			Ложь);
		Для Каждого ТочкаМаршрута Из ТочкиМаршрута Цикл
			ДобавитьСтроку(Строка, "ТочкаМаршрута", Строка.ТипПроцесса, Строка.Шаблон, ТочкаМаршрута, Строка.ШаблонКомплексногоПроцесса);
		КонецЦикла;
		
	ИначеЕсли СтрНачинаетсяС(Строка.НазначениеСтроки, "Шаблон")
		И Перечисления.ТипыПроцессовЭскалацииЗадач.ЭтоКомплексныйПроцесс(Строка.ТипПроцесса) Тогда
		
		СхемаШаблона = ОбщегоНазначенияДокументооборот.ЗначениеРеквизитаОбъектаВПривилегированномРежиме(
			Строка.Шаблон, "Схема");
		
		Запрос = Новый Запрос;
		Если ЗначениеЗаполнено(СхемаШаблона) Тогда
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	СхемыКомплексныхПроцессовПараметрыДействий.ШаблонПроцесса КАК ШаблонБизнесПроцесса
				|ИЗ
				|	Справочник.СхемыКомплексныхПроцессов.ПараметрыДействий КАК СхемыКомплексныхПроцессовПараметрыДействий
				|ГДЕ
				|	СхемыКомплексныхПроцессовПараметрыДействий.Ссылка = &Ссылка";
			Запрос.УстановитьПараметр("Ссылка", СхемаШаблона);
		Иначе
			Запрос.Текст = 
				"ВЫБРАТЬ РАЗРЕШЕННЫЕ
				|	ШаблоныКомплексныхБизнесПроцессовЭтапы.ШаблонБизнесПроцесса
				|ИЗ
				|	Справочник.ШаблоныКомплексныхБизнесПроцессов.Этапы КАК ШаблоныКомплексныхБизнесПроцессовЭтапы
				|ГДЕ
				|	ШаблоныКомплексныхБизнесПроцессовЭтапы.Ссылка = &Ссылка
				|
				|УПОРЯДОЧИТЬ ПО
				|	ШаблоныКомплексныхБизнесПроцессовЭтапы.НомерСтроки";
			Запрос.УстановитьПараметр("Ссылка", Строка.Шаблон);
		КонецЕсли;
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			ДобавитьСтроку(Строка, "ШаблонЭтапа", , Выборка.ШаблонБизнесПроцесса,, Строка.ШаблонКомплексногоПроцесса);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьСтроку(
	Строка,
	НазначениеСтроки,
	ТипПроцесса = Неопределено,
	Шаблон = Неопределено,
	ТочкаМаршрута = Неопределено,
	ШаблонКомплексногоПроцесса = Неопределено)
	
	НоваяСтрока = Строка.Строки.Добавить();
	НоваяСтрока.НазначениеСтроки = НазначениеСтроки;
	НоваяСтрока.ТипПроцесса = ТипПроцесса;
	НоваяСтрока.Шаблон = Шаблон;
	НоваяСтрока.ШаблонКомплексногоПроцесса = ШаблонКомплексногоПроцесса;
	НоваяСтрока.ТочкаМаршрута = ТочкаМаршрута;
	НоваяСтрока.ВременныйИдентификатор = Новый УникальныйИдентификатор;
	НоваяСтрока.ИндексКартинки = -1;
	
	Если НоваяСтрока.НазначениеСтроки = "ТипПроцесса" Тогда
		НоваяСтрока.Представление = НоваяСтрока.ТипПроцесса;
	ИначеЕсли СтрНачинаетсяС(НоваяСтрока.НазначениеСтроки, "Шаблон") Тогда
		НоваяСтрока.Представление = НоваяСтрока.Шаблон;
		НоваяСтрока.ТипПроцесса = Перечисления.ТипыПроцессовЭскалацииЗадач.ТипПроцессаПоШаблону(НоваяСтрока.Шаблон);
		НоваяСтрока.ИндексКартинки = 0;
	ИначеЕсли НоваяСтрока.НазначениеСтроки = "ТочкаМаршрута" Тогда
		НоваяСтрока.Представление = НоваяСтрока.ТочкаМаршрута;
		НоваяСтрока.ИндексКартинки = 1;
	ИначеЕсли НоваяСтрока.НазначениеСтроки = "БезШаблона" Тогда
		ДанныеШаблона = Перечисления.ТипыПроцессовЭскалацииЗадач.ДанныеШаблона(НоваяСтрока.ТипПроцесса);
		НоваяСтрока.Представление = СтрШаблон("<%1>", НСтр("ru = 'Без шаблона'"));
		НоваяСтрока.Шаблон = ДанныеШаблона.ПустаяСсылка;
		НоваяСтрока.ИндексКартинки = 0;
	КонецЕсли;
	
	Если ШаблонКомплексногоПроцесса = Неопределено
		И ТипЗнч(НоваяСтрока.Шаблон) = Тип("СправочникСсылка.ШаблоныКомплексныхБизнесПроцессов") Тогда
		НоваяСтрока.ШаблонКомплексногоПроцесса = НоваяСтрока.Шаблон;
	КонецЕсли;
	
	ЗаполнитьПодчиненныеЭлементы(НоваяСтрока);
	
	Возврат НоваяСтрока;
	
КонецФункции

&НаСервере
Функция ИдентификаторСтрокиШаблона(Реквизит, Шаблон)
	
	ИдентификаторСтрокиШаблона = 0;
	
	НайденЭлемент = Ложь;
	ЭлементыКОбработке = Новый Массив;
	ЭлементыКОбработке.Добавить(Реквизит);
	Пока ЭлементыКОбработке.Количество() > 0 Цикл
		ЭлеменетКОбработке = ЭлементыКОбработке[0];
		ЭлементыКОбработке.Удалить(0);
		Для Каждого ПодчиненныйЭлемент Из ЭлеменетКОбработке.ПолучитьЭлементы() Цикл
			ЭлементыКОбработке.Добавить(ПодчиненныйЭлемент);
			Если ПодчиненныйЭлемент.Шаблон = Шаблон
				И (ПодчиненныйЭлемент.НазначениеСтроки = "Шаблон"
					Или ПодчиненныйЭлемент.НазначениеСтроки = "БезШаблона") Тогда
				ИдентификаторСтрокиШаблона = ПодчиненныйЭлемент.ПолучитьИдентификатор();
				НайденЭлемент = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если НайденЭлемент Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИдентификаторСтрокиШаблона;
	
КонецФункции

&НаКлиенте
Процедура ЗапомнитьСостояниеДеревоПроцессов(Элемент, Реквизит)
	
	ДеревоПроцессовРазвернутыеЭлементы = Новый Массив;
	
	ЭлементыКОбработке = Новый Массив;
	ЭлементыКОбработке.Добавить(Реквизит);
	Пока ЭлементыКОбработке.Количество() > 0 Цикл
		ЭлеменетКОбработке = ЭлементыКОбработке[0];
		ЭлементыКОбработке.Удалить(0);
		Для Каждого ПодчиненныйЭлемент Из ЭлеменетКОбработке.ПолучитьЭлементы() Цикл
			ИдентификаторСтроки = ПодчиненныйЭлемент.ПолучитьИдентификатор();
			Если Элемент.Развернут(ИдентификаторСтроки) Тогда
				ЭлементыКОбработке.Добавить(ПодчиненныйЭлемент);
				ДеревоПроцессовРазвернутыеЭлементы.Добавить(ПодчиненныйЭлемент.ВременныйИдентификатор);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВосстановитьСостояниеДеревоПроцессов(Элемент, Реквизит)
	
	ЭлементыКОбработке = Новый Массив;
	ЭлементыКОбработке.Добавить(Реквизит);
	Пока ЭлементыКОбработке.Количество() > 0 Цикл
		ЭлеменетКОбработке = ЭлементыКОбработке[0];
		ЭлементыКОбработке.Удалить(0);
		Для Каждого ПодчиненныйЭлемент Из ЭлеменетКОбработке.ПолучитьЭлементы() Цикл
			ЭлементыКОбработке.Добавить(ПодчиненныйЭлемент);
			ИдентификаторСтроки = ПодчиненныйЭлемент.ПолучитьИдентификатор();
			Если ДеревоПроцессовРазвернутыеЭлементы.Найти(ПодчиненныйЭлемент.ВременныйИдентификатор) <> Неопределено Тогда
				Элемент.Развернуть(ИдентификаторСтроки);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьДеревоПроцессов(ИмяРеквизита, Данные, Количество)
	
	ЗаполнитьДеревоПроцессов(ИмяРеквизита, Данные);
	ОбновитьЗначениеПометокДеревоПроцессов(ЭтаФорма[ИмяРеквизита], Количество);
	СортироватьДеревоПроцессов(ИмяРеквизита);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоПроцессов(ИмяРеквизита, Данные)
	
	ЗначениеДеревоПроцессов = РеквизитФормыВЗначение(ИмяРеквизита);
	ЗначениеДеревоПроцессов.Строки.Очистить();
	
	Для Каждого Процесс Из Данные Цикл
		Если ЗначениеЗаполнено(Процесс.Шаблон)
			И Не ОбщегоНазначения.СсылкаСуществует(Процесс.Шаблон) Тогда
			Продолжить;
		КонецЕсли;
		ОтметитьПроцесс(
			ЗначениеДеревоПроцессов,
			Процесс.ТипПроцесса,
			Процесс.Шаблон,
			Процесс.ТочкаМаршрута,
			Процесс.ШаблонКомплексногоПроцесса);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ЗначениеДеревоПроцессов, ИмяРеквизита);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОбновитьЗначениеПометокДеревоПроцессов(Реквизит, Количество)
	
	Количество = 0;
	
	ЭлементыДерева = Новый Массив;
	ЭлементыКОбработке = Новый Массив;
	ЭлементыКОбработке.Добавить(Реквизит);
	Пока ЭлементыКОбработке.Количество() > 0 Цикл
		ЭлементКОбработке = ЭлементыКОбработке[0];
		ЭлементыКОбработке.Удалить(0);
		Для Каждого Элемент Из ЭлементКОбработке.ПолучитьЭлементы() Цикл
			ЭлементыКОбработке.Добавить(Элемент);
			ЭлементыДерева.Вставить(0, Элемент);
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого Элемент Из ЭлементыДерева Цикл
		
		КоличествоПодчиненныхПометок = 0;
		КоличествоПодчиненных = 0;
		ПодчиненныеСПометкой = 0;
		Для Каждого ПодчиненныйЭлемент Из Элемент.ПолучитьЭлементы() Цикл
			
			КоличествоПодчиненных = КоличествоПодчиненных + 1;
			
			Если ПодчиненныйЭлемент.Пометка = 1 Тогда
				ПодчиненныеСПометкой = ПодчиненныеСПометкой + 1;
			ИначеЕсли ПодчиненныйЭлемент.Пометка = 2 Тогда
				ПодчиненныеСПометкой = ПодчиненныеСПометкой + 0.5;
			КонецЕсли;
			
			Если ПодчиненныйЭлемент.НазначениеСтроки = "ТочкаМаршрута" Тогда
				
				Если ПодчиненныйЭлемент.Пометка Тогда
					КоличествоПодчиненныхПометок = КоличествоПодчиненныхПометок + 1;
				КонецЕсли;
				
			Иначе
				
				КоличествоПодчиненныхПометок = КоличествоПодчиненныхПометок + ПодчиненныйЭлемент.КоличествоПодчиненныхПометок;
				
			КонецЕсли;
			
		КонецЦикла;
		
		Если КоличествоПодчиненных <> 0 Тогда
			
			Если Элемент.НазначениеСтроки = "ТипПроцесса"
				Или ПодчиненныеСПометкой = 0 Тогда
				Элемент.Пометка = 0;
			ИначеЕсли ПодчиненныеСПометкой = КоличествоПодчиненных Тогда
				Элемент.Пометка = 1;
			Иначе
				Элемент.Пометка = 2;
			КонецЕсли;
			
		КонецЕсли;
		
		Элемент.КоличествоПодчиненныхПометок = КоличествоПодчиненныхПометок;
		Элемент.ЕстьПометкиПодчиненных = Элемент.КоличествоПодчиненныхПометок <> 0;
		Если Элемент.КоличествоПодчиненныхПометок <> 0 Тогда
			Элемент.ПредставлениеСКоличеством = СтрШаблон("%1 (%2)",
				Элемент.Представление,
				Элемент.КоличествоПодчиненныхПометок);
		Иначе
			Элемент.ПредставлениеСКоличеством = Элемент.Представление;
		КонецЕсли;
		
		Если Элемент.НазначениеСтроки = "ТипПроцесса" Тогда
			Количество = Количество + Элемент.КоличествоПодчиненныхПометок;
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

&НаСервере
Процедура СортироватьДеревоПроцессов(ИмяРеквизита)
	
	ЗначениеДеревоПроцессов = РеквизитФормыВЗначение(ИмяРеквизита);
	ЗначениеДеревоПроцессов.Строки.Сортировать("ЕстьПометкиПодчиненных Убыв, ПредставлениеСКоличеством");
	ЗначениеВРеквизитФормы(ЗначениеДеревоПроцессов, ИмяРеквизита);
	
КонецПроцедуры

&НаСервере
Функция ПеренестиПроцессыВТабличнуюЧасть(Данные, ИмяРеквизита)
	
	ЗначениеРеквизита = РеквизитФормыВЗначение(ИмяРеквизита);
	
	Данные.Очистить();
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("НазначениеСтроки", "ТочкаМаршрута");
	ПараметрыОтбора.Вставить("Пометка", 1);
	НайденныеСтроки = ЗначениеРеквизита.Строки.НайтиСтроки(ПараметрыОтбора, Истина);
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		НоваяСтока = Данные.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтока, НайденнаяСтрока);
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Процедура ДеревоПроцессовПриИзмененииОбработка(Элемент, Реквизит, Количество)
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.Пометка = 2 Тогда
		ТекущиеДанные.Пометка = 0;
	КонецЕсли;
	
	Если СтрНачинаетсяС(ТекущиеДанные.НазначениеСтроки, "Шаблон")
		Или ТекущиеДанные.НазначениеСтроки = "БезШаблона" Тогда
		НоваяПометка = ТекущиеДанные.Пометка;
		ЭлементыКОбработке = Новый Массив;
		ЭлементыКОбработке.Добавить(ТекущиеДанные);
		Пока ЭлементыКОбработке.Количество() > 0 Цикл
			ЭлементКОбработке = ЭлементыКОбработке[0];
			ЭлементыКОбработке.Удалить(0);
			Для Каждого ОбрабатываемыйЭлемент Из ЭлементКОбработке.ПолучитьЭлементы() Цикл
				ЭлементыКОбработке.Добавить(ОбрабатываемыйЭлемент);
				ОбрабатываемыйЭлемент.Пометка = НоваяПометка;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	ОбновитьЗначениеПометокДеревоПроцессов(Реквизит, Количество);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПроцессовВыборОбработка(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрНачинаетсяС(ТекущиеДанные.НазначениеСтроки, "Шаблон") Тогда
		ПоказатьЗначение(, ТекущиеДанные.Шаблон);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СтрокаТипПроцесса(ЗначениеДеревоПроцессов, ТипПроцесса)
	
	СтрокаТипПроцесса = ЗначениеДеревоПроцессов.Строки.Найти(ТипПроцесса, "ТипПроцесса");
	Если СтрокаТипПроцесса = Неопределено Тогда
		СтрокаТипПроцесса = ДобавитьСтроку(ЗначениеДеревоПроцессов, "ТипПроцесса", ТипПроцесса);
	КонецЕсли;
	
	Возврат СтрокаТипПроцесса;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьПроцессЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Истина;
	
	ЗапомнитьСостояниеДеревоПроцессов(
		Элементы.ДеревоПроцессов,
		ДеревоПроцессов);
	Если ТипЗнч(Результат) = Тип("ПеречислениеСсылка.ТипыПроцессовЭскалацииЗадач") Тогда
		ТекущаяСтрока = ДобавитьБезШаблонВДеревоПроцессов(
			"ДеревоПроцессов",
			КоличествоПроцессов,
			Результат);
	Иначе
		ТекущаяСтрока = ДобавитьШаблонВДеревоПроцессов(
			"ДеревоПроцессов",
			КоличествоПроцессов,
			Результат);
	КонецЕсли;
	ВосстановитьСостояниеДеревоПроцессов(
		Элементы.ДеревоПроцессов,
		ДеревоПроцессов);
	Элементы.ДеревоПроцессов.ТекущаяСтрока = ТекущаяСтрока;
	Элементы.ДеревоПроцессов.Развернуть(ТекущаяСтрока, Истина);
	
КонецПроцедуры

#КонецОбласти
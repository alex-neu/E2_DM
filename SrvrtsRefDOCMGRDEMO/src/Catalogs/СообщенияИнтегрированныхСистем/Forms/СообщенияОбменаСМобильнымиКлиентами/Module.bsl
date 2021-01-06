
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Список.Параметры.УстановитьЗначениеПараметра("ОграничиватьПоПользователю", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("ОграничиватьПоКлиенту", Ложь);
	Список.Параметры.УстановитьЗначениеПараметра("Клиент", Неопределено);
	Список.Параметры.УстановитьЗначениеПараметра("Пользователь", Неопределено);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура МобильныйКлиентПриИзменении(Элемент)

	Список.Параметры.УстановитьЗначениеПараметра("ОграничиватьПоКлиенту", Ложь);

	Если ЗначениеЗаполнено(МобильныйКлиент) Тогда
		Список.Параметры.УстановитьЗначениеПараметра("ОграничиватьПоКлиенту", Истина);
		Список.Параметры.УстановитьЗначениеПараметра("Клиент", МобильныйКлиент);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПользовательПриИзменении(Элемент)

	Если ЗначениеЗаполнено(Пользователь) Тогда

		МобильныйКлиент = Неопределено;
		МобильныеКлиенты = 
			ОбменСМобильнымиВызовСервера.ПолучитьУзлыОбменаПоВладельцу(Пользователь);

		Список.Параметры.УстановитьЗначениеПараметра("ОграничиватьПоПользователю", Истина);
		Список.Параметры.УстановитьЗначениеПараметра("Пользователь", Пользователь);
		Список.Параметры.УстановитьЗначениеПараметра("ОграничиватьПоКлиенту", Ложь);

		Если МобильныеКлиенты.Количество() = 1 Тогда

			МобильныйКлиент = МобильныеКлиенты[0];
			Список.Параметры.УстановитьЗначениеПараметра("ОграничиватьПоКлиенту", Истина);
			Список.Параметры.УстановитьЗначениеПараметра("Клиент", МобильныйКлиент);

		КонецЕсли;

	Иначе

		МобильныйКлиент = Неопределено;
		Список.Параметры.УстановитьЗначениеПараметра("ОграничиватьПоПользователю", Ложь);
		Список.Параметры.УстановитьЗначениеПараметра("ОграничиватьПоКлиенту", Ложь);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ОткрытьСообщение();

КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда

		ДанныхВСообщении = 0;
		РазмерСообщения = 0;

		Возврат;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПросмотретьСообщение(Команда)

	#Если Не ВебКлиент Тогда

		ОткрытьСообщение();

	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура УдалитьСообщение(Команда)

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ЗаголовокВопроса = НСтр("ru = 'Удаление сообщения'");
	Если Не ТекущиеДанные.Входящее И ЗначениеЗаполнено(ТекущиеДанные.ДатаПередачиКлиенту) 
		Или ТекущиеДанные.Входящее И ЗначениеЗаполнено(ТекущиеДанные.ДатаОбработки) Тогда
		ТекстВопроса = НСтр("ru = 'Сообщение будет удалено без возможности восстановления. Продолжить?'");
	Иначе
		ТекстВопроса = НСтр("ru = 'Внимание! Данное сообщение еще не передано клиенту!
			|Сообщение будет удалено без возможности восстановления.
			|Данные из сообщении не будут переданы на мобильный клиент.
			|Продолжить?'");
	КонецЕсли;

	ОписаниеОповещения = Новый ОписаниеОповещения(
		"УдалитьСообщениеПродолжение",
		ЭтотОбъект);

	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, 
		КодВозвратаДиалога.Нет, ЗаголовокВопроса);

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПереданныеСообщения(Команда)

	ТекстСообщения = НСтр("ru = 'Будут удалены все переданные сообщения для всех получателей. Продолжить?'");
	ЗаголовокВопроса = НСтр("ru = 'Удаление сообщений'");

	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ОчиститьПереданныеСообщенияПродолжение",
		ЭтотОбъект);
	ПоказатьВопрос(
		ОписаниеОповещения, 
		ТекстСообщения, 
		РежимДиалогаВопрос.ДаНет,, 
		КодВозвратаДиалога.Нет, 
		ЗаголовокВопроса);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьСообщение()
	
	#Если Не ВебКлиент Тогда
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Состояние(НСтр("ru = 'Сообщение открывается. Пожалуйста, подождите...'"));
	Сообщение = ТекущиеДанные.Ссылка;
	ДвоичныеДанные = ПросмотретьСообщениеНаСервере(Сообщение);
	Если ДвоичныеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТипЗнч(ТекущиеДанные.МобильныйКлиент) = Тип("СправочникСсылка.ПользователиМобильногоПриложения") Тогда
		ИмяФайла = ПолучитьИмяВременногоФайла("txt");
	Иначе
		ИмяФайла = ПолучитьИмяВременногоФайла("xml");
	КонецЕсли;
	ДвоичныеДанные.Записать(ИмяФайла);
	ЗапуститьПриложение(ИмяФайла);
	#КонецЕсли
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПросмотретьСообщениеНаСервере(Сообщение)
	
	ДанныеСообщения = Сообщение.ДанныеСообщения.Получить();
	
	Если ТипЗнч(ДанныеСообщения) = Тип("ДвоичныеДанные") Тогда
		Возврат ДанныеСообщения;
	Иначе
		МассивЧастей = ДанныеСообщения;
		Если МассивЧастей = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ФайлСообщения = ПолучитьИмяВременногоФайла("xml");
		МассивФайловЧастей = Новый Массив;
		Для Каждого Часть Из МассивЧастей Цикл
			ИмяФайлаЧасти = ПолучитьИмяВременногоФайла("xml");
			Если ТипЗнч(Часть) = Тип("ДвоичныеДанные") Тогда
				ДвоичныеДанныеЧасти = Часть;
			Иначе
				ДвоичныеДанныеЧасти = Часть.Получить();
			КонецЕсли;
			ДвоичныеДанныеЧасти.Записать(ИмяФайлаЧасти);
			МассивФайловЧастей.Добавить(ИмяФайлаЧасти);
		КонецЦикла;
		
		ОбъединитьФайлы(МассивФайловЧастей, ФайлСообщения);
		ДвоичныеДанныеФайла = Новый ДвоичныеДанные(ФайлСообщения);
		
		Для Каждого ИмяФайла Из МассивФайловЧастей Цикл
			УдалитьФайлы(ИмяФайла);
		КонецЦикла;
		
		УдалитьФайлы(ФайлСообщения);
		
		Возврат ДвоичныеДанныеФайла;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Процедура УдалитьСообщениеСервер(Сообщение)

	УстановитьПривилегированныйРежим(Истина);
	СообщениеОбъект = Сообщение.ПолучитьОбъект();
	СообщениеОбъект.Удалить();

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПереданныеСообщенияПродолжение(Ответ, Параметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МобильныйКлиент) Тогда
		ОбменСМобильнымиВызовСервера.УдалениеСообщенийИнтеграцииПоКлиенту(МобильныйКлиент);
	Иначе
		ОбменСМобильнымиВызовСервера.УдалениеСообщенийИнтеграцииСМобильнымКлиентом();
	КонецЕсли;
	
	ОповеститьОбИзменении(Тип("СправочникСсылка.СообщенияИнтегрированныхСистем"));	
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьСообщениеПродолжение(Ответ, Параметры) Экспорт

	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	ЗаголовокВопроса = НСтр("ru = 'Удаление сообщения'");
	ОписаниеОповещения = Новый ОписаниеОповещения("УдалитьСообщениеПродолжение2", ЭтотОбъект);

	Если Не ЗначениеЗаполнено(ТекущиеДанные.ДатаПередачиКлиенту) Тогда

		ТекстВопроса = НСтр("ru = 'Вы уверены?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, 
			РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет, ЗаголовокВопроса);

	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УдалитьСообщениеПродолжение2(Ответ, Параметры) Экспорт

	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;

	УдалитьСообщениеСервер(ТекущиеДанные.Ссылка);

	ОповеститьОбИзменении(Тип("СправочникСсылка.СообщенияИнтегрированныхСистем"));

КонецПроцедуры

#КонецОбласти


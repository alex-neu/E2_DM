#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Скрытие служебных пользователей.
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ПользователиСписок, "Служебный", Ложь, , , Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный,
			Строка(Новый УникальныйИдентификатор));
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			ПользователиСписок, "Служебный", Ложь, , , Истина);
	КонецЕсли;
	
	Элементы.ФормаПоказыватьНедействительныхПользователей.Пометка = ПоказыватьНедействительныхПользователей;
	ОформитьИСкрытьНедействительныхПользователей();
	НастроитьПараметрыСпискаПользователейДляКомандыУстановитьПароль();
	
	//Если Не ПравоДоступа("Добавление", Метаданные.Справочники.Пользователи) Тогда
	//	Элементы.СоздатьПользователя.Видимость = Ложь;
	//КонецЕсли;
	
	РазделениеВключено = ОбщегоНазначения.РазделениеВключено();
	Если НЕ Пользователи.ЭтоПолноправныйПользователь(, Не РазделениеВключено) Тогда
		Если Элементы.Найти("ПользователиИБ") <> Неопределено Тогда
			Элементы.ПользователиИБ.Видимость = Ложь;
		КонецЕсли;
		Элементы.СведенияОПользователях.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов")
		Или ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		Элементы.ФормаИзменитьВыделенные.Видимость = Ложь;
		Элементы.ПользователиСписокКонтекстноеМенюИзменитьВыделенные.Видимость = Ложь;
	КонецЕсли;
	
	ОписаниеОбъекта = Новый Структура;
	ОписаниеОбъекта.Вставить("Ссылка", Справочники.Пользователи.ПустаяСсылка());
	ОписаниеОбъекта.Вставить("ИдентификаторПользователяИБ", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	УровеньДоступа = ПользователиСлужебный.УровеньДоступаКСвойствамПользователя(ОписаниеОбъекта);
	
	Если Не УровеньДоступа.УправлениеСписком Тогда
		Элементы.ФормаУстановитьПароль.Видимость = Ложь;
		Элементы.ПользователиСписокКонтекстноеМенюУстановитьПароль.Видимость = Ложь;
		Элементы.ФормаГруппыИПолномочия.Видимость = Ложь;
		Элементы.ПользователиСписокКонтекстноеМенюГруппыИПолномочия.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрыРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрыРазмещения.КоманднаяПанель = Элементы.ГруппаПечать;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Элементы.ФормаПоказыватьНедействительныхПользователей.Пометка = ПоказыватьНедействительныхПользователей;
	ПереключитьОтображениеНедействительныхПользователей(ПользователиСписок, ПоказыватьНедействительныхПользователей);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПользователиСписок

&НаКлиенте
Процедура ПользователиСписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьПоказыватьНедействительныхПользователей(Команда)
	
	ПоказыватьНедействительныхПользователей = Не ПоказыватьНедействительныхПользователей;
	Элементы.ФормаПоказыватьНедействительныхПользователей.Пометка = ПоказыватьНедействительныхПользователей;
	ПереключитьОтображениеНедействительныхПользователей(ПользователиСписок, ПоказыватьНедействительныхПользователей);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПароль(Команда)
	
	ТекущиеДанные = Элементы.ПользователиСписок.ТекущиеДанные;
	
	Если СтандартныеПодсистемыКлиент.ЭтоЭлементДинамическогоСписка(ТекущиеДанные) Тогда
		ПользователиСлужебныйКлиент.ОткрытьФормуСменыПароля(ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппыИПолномочия(Команда)
	
	Если Элементы.ПользователиСписок.ТекущиеДанные = Неопределено
		Или ТипЗнч(Элементы.ПользователиСписок.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Пользователь", Элементы.ПользователиСписок.ТекущаяСтрока);
	
	ОткрытьФорму("ОбщаяФорма.ГруппыИПолномочия",
		ПараметрыФормы, ЭтотОбъект,
		Элементы.ПользователиСписок.ТекущаяСтрока);
		
КонецПроцедуры

&НаКлиенте
Процедура СведенияОПользователях(Команда)
	
	ОткрытьФорму(
		"Отчет.СведенияОПользователях.ФормаОбъекта",
		Новый Структура("КлючВарианта", "СведенияОПользователях"),
		ЭтотОбъект,
		"СведенияОПользователях");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Поддержка группового изменения объектов.

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов") Тогда
		МодульГрупповоеИзменениеОбъектовКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ГрупповоеИзменениеОбъектовКлиент");
		МодульГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.ПользователиСписок);
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.ПользователиСписок);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.ПользователиСписок, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.ПользователиСписок);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОформитьИСкрытьНедействительныхПользователей()
	
	// Оформление.
	
	// Цвет недействительных.
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("ЦветТекста");
	ЭлементЦветаОформления.Значение = Метаданные.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет.Значение;
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ПользователиСписок.Недействителен");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("ПользователиСписок");
	ЭлементОформляемогоПоля.Использование = Истина;
	
	// Шрифт удаленных.
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементШрифтаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("Шрифт");
	ЭлементШрифтаОформления.Значение = Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста,,,,,, Истина);
	ЭлементШрифтаОформления.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ПользователиСписок.ПометкаУдаления");
	ЭлементОтбораДанных.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Истина;
	ЭлементОтбораДанных.Использование  = Истина;
	
	ЭлементОформляемогоПоля = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОформляемогоПоля.Поле = Новый ПолеКомпоновкиДанных("ПользователиСписок");
	ЭлементОформляемогоПоля.Использование = Истина;
	
	
	// Видимость.
	ПереключитьОтображениеНедействительныхПользователей(ПользователиСписок, ПоказыватьНедействительныхПользователей);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПараметрыСпискаПользователейДляКомандыУстановитьПароль()
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ИдентификаторТекущегоПользователяИБ",
		ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор);
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ПустойУникальныйИдентификатор",
		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	ОбновитьЗначениеПараметраКомпоновкиДанных(ПользователиСписок, "ВозможноСменитьТолькоСвойПароль",
		Не Пользователи.ЭтоПолноправныйПользователь());
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьЗначениеПараметраКомпоновкиДанных(Знач ВладелецПараметров,
                                                    Знач ИмяПараметра,
                                                    Знач ЗначениеПараметра)
	
	Для каждого Параметр Из ВладелецПараметров.Параметры.Элементы Цикл
		Если Строка(Параметр.Параметр) = ИмяПараметра Тогда
			
			Если Параметр.Использование
			   И Параметр.Значение = ЗначениеПараметра Тогда
				Возврат;
			КонецЕсли;
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
	
	ВладелецПараметров.Параметры.УстановитьЗначениеПараметра(ИмяПараметра, ЗначениеПараметра);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПереключитьОтображениеНедействительныхПользователей(ПользователиСписок, ПоказатьНедействительных)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ПользователиСписок, "Недействителен", Ложь, , , Не ПоказатьНедействительных,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Авто,
		Строка(Новый УникальныйИдентификатор));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ПользователиСписок, "ПометкаУдаления", Ложь, , , Не ПоказатьНедействительных,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Авто,
		Строка(Новый УникальныйИдентификатор));
	
КонецПроцедуры

#КонецОбласти

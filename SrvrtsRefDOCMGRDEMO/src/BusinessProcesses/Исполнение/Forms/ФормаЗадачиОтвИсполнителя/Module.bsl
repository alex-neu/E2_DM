&НаКлиенте
Перем ПолноеИмяПеретаскиваемогоФайла;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	
	РаботаСБизнесПроцессамиВызовСервера.ФормаЗадачиПриСозданииНаСервере(
		ЭтаФорма,
		Объект);
		
	РаботаСБизнесПроцессамиВызовСервера.ЗаполнитьУсловноеОФормлениеПодзадачи(ЭтаФорма, Объект);
	РаботаСБизнесПроцессамиВызовСервера.ЗаполнитьПодзадачи(ЭтаФорма, Объект);
		
	Исполнители.Параметры.УстановитьЗначениеПараметра("БизнесПроцесс", Объект.БизнесПроцесс);
	Исполнители.Параметры.УстановитьЗначениеПараметра("ТочкаМаршрута", БизнесПроцессы.Исполнение.ТочкиМаршрута.Исполнить);
	Исполнители.Параметры.УстановитьЗначениеПараметра("ИспользоватьДатуИВремяВСрокахЗадач", ИспользоватьДатуИВремяВСрокахЗадач);
	
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Исполнители.УсловноеОформление);
	
	РаботаСБизнесПроцессамиВызовСервера.УстановитьФорматДаты(Элементы.ИсполнителиСрокИсполнения);
	РаботаСБизнесПроцессамиВызовСервера.УстановитьФорматДаты(Элементы.ИсполнителиДатаИсполнения);
	
	УчетВремени.ПроинициализироватьПараметрыУчетаВремени(
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ОпцияИспользоватьУчетВремени,
		Объект.Ссылка,
		ВидыРабот,
		СпособУказанияВремени,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		ЭтаФорма.Элементы.УказатьТрудозатраты);
		

	БизнесПроцессыИЗадачиВызовСервера.ЗаписатьСобытиеОткрытаКарточкаИОбращениеКОбъекту(Объект.Ссылка);
	
	ПраваПоОбъекту = ДокументооборотПраваДоступа.ПолучитьПраваПоОбъекту(Объект.Ссылка);
	Если Не ПраваПоОбъекту.Изменение Тогда
		ТолькоПросмотр = Истина;
		Элементы.Исполнено.Доступность = Ложь;
		
		Элементы.ДеревоПриложений.ИзменятьПорядокСтрок = Ложь;
		Элементы.ДеревоПриложений.ИзменятьСоставСтрок = Ложь;
		
		Элементы.Перенаправить.Доступность = Ложь;
		Элементы.ФормаПринятьКИсполнению.Доступность = Ложь;
		Элементы.ФормаОтменитьПринятиеКИсполнению.Доступность = Ложь;
		Элементы.ИзменитьДатуВыполнения.Доступность = Ложь;
	КонецЕсли;
	
	Если Объект.СостояниеБизнесПроцесса <> Перечисления.СостоянияБизнесПроцессов.Активен
		Или Объект.Выполнена Тогда
		
		Элементы.ДеревоПриложений.ИзменятьПорядокСтрок = Ложь;
		Элементы.ДеревоПриложений.ИзменятьСоставСтрок = Ложь;
	КонецЕсли;
	
	// Инструкции
	ПоказыватьИнструкции = ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции");
	ПолучитьИнструкции();
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		НастроитьЭлементыФормыДляМобильногоУстройства();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Оповестить("ОбновитьСписокПоследних");
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыРеквизитыНевыполненныхЗадач" И Параметр = Объект.БизнесПроцесс И Не Объект.Выполнена Тогда 
		
		ДатаИсполнения = Объект.ДатаИсполнения;
		Прочитать();
		ПредставлениеHTML = ОбзорЗадачВызовСервера.ПолучитьОбзорЗадачи(Объект);
		Объект.ДатаИсполнения = ДатаИсполнения;
		
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "ДанныеФайлаИзменены" Тогда
		
		ОбновитьДеревоПриложений();
		
	ИначеЕсли ИмяСобытия = "Изменение_ФактическиеТрудозатратыЗадачи" И Параметр = Объект.Ссылка Тогда
		
		ТрудозатратыФакт = РаботаСБизнесПроцессамиВызовСервера.ПолучитьФактическиеТрудозатратыПоЗадаче(Объект.Ссылка);	
		
	ИначеЕсли ИмяСобытия = "ФайлЗанятДляРедактирования" Тогда
		
		ОбновитьДеревоПриложений();
		
	ИначеЕсли ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" И Параметр.ИдентификаторРодительскойФормы = УникальныйИдентификатор Тогда
		
		МультипредметностьВызовСервера.ОбработатьДобавлениеПредметаЗадачи(
			Объект.Ссылка, Объект.БизнесПроцесс, Параметр.Файл, УникальныйИдентификатор);
			
		Прочитать();
		ПредставлениеHTML = ОбзорЗадачВызовСервера.ПолучитьОбзорЗадачи(Объект);
		ОбновитьДеревоПриложений();
		
	ИначеЕсли ИмяСобытия = "ИзменилсяФлаг"
		И Источник <> ЭтаФорма
		И Параметр.Найти(Объект.Ссылка) <> Неопределено Тогда
		
		РаботаСФлагамиОбъектовКлиентСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
		
	ИначеЕсли ИмяСобытия = "СозданНовыйВопросВыполненияЗадачи" И Параметр = Объект.Ссылка Тогда
		
		БизнесПроцессыИЗадачиКлиентСервер.ЗаполнитьЗаголовокКомандыЗадатьВопрос(ЭтаФорма);
		
	ИначеЕсли ИмяСобытия = "ЗадачаИзменена" И Источник <> ЭтаФорма Тогда
		
		ПрочитатьДанныеЗадачиВФорму = Ложь;
		
		Если ТипЗнч(Параметр) = Тип("Массив") Тогда
			ПрочитатьДанныеЗадачиВФорму = Параметр.Найти(Объект.Ссылка) <> Неопределено;
		Иначе
			ПрочитатьДанныеЗадачиВФорму = (Параметр = Объект.Ссылка);
		КонецЕсли;
		
		Если ПрочитатьДанныеЗадачиВФорму Тогда
			Прочитать();
			ПредставлениеHTML = ОбзорЗадачВызовСервера.ПолучитьОбзорЗадачи(Объект);
		КонецЕсли;
		
		КомандыРаботыСБизнесПроцессамиКлиент.ОбновитьДоступностьКомандПринятияКИсполнению(ЭтаФорма);
		
	ИначеЕсли ИмяСобытия = "Перенаправление_ЗадачаИсполнителя" 
		И Источник.Получить(Объект.Ссылка) <> Неопределено Тогда
		Закрыть();
	ИначеЕсли ИмяСобытия = "ЗаписьКонтроля"
		И Параметр.Предмет = Объект.Ссылка Тогда
		
		ПредставлениеHTML = ОбзорЗадачВызовСервера.ПолучитьОбзорЗадачи(Объект);
		
	ИначеЕсли (ИмяСобытия = "БизнесПроцессСтартован" Или ИмяСобытия = "ФоновыйСтартПроцесса") 
		И Параметр.Свойство("ГлавнаяЗадача") И Параметр.ГлавнаяЗадача = Объект.Ссылка Тогда
		
		ОбновитьПодзадачи();
		
	ИначеЕсли (ИмяСобытия = "ЗадачаВыполнена" 
		И РаботаСБизнесПроцессамиКлиент.ЗадачаЕстьВТаблицеЗадач(ЭтаФорма, Параметр)) Тогда
		
		ОбновитьПодзадачи();
		
	ИначеЕсли ИмяСобытия = "БизнесПроцессИзменен" 
		И РаботаСБизнесПроцессамиКлиент.ПроцессЕстьВТаблицеЗадач(ЭтаФорма, Параметр) Тогда 
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если Мультипредметность.ИзмененыПредметыЗадачи(Объект.Ссылка) Тогда
			ОбновитьДеревоПриложенийСервер();
		КонецЕсли;
	КонецЕсли;
	
	РаботаСБизнесПроцессамиВызовСервера.ФормаЗадачиИсполнителяУстановитьВидимостьПредмета(ЭтаФорма);
	
	Если Не Объект.Выполнена Тогда
		Объект.ДатаИсполнения = ТекущаяДатаСеанса();
	КонецЕсли;
	
	РаботаСФлагамиОбъектовСервер.ОтобразитьФлагВФормеОбъекта(ЭтаФорма);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСБизнесПроцессами.ФормаЗадачиПередЗаписьюНаСервере(
		ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСБизнесПроцессами.ФормаЗадачиПриЗаписиНаСервере(
		ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	РаботаСБизнесПроцессамиВызовСервера.ФормаЗадачиИсполнителяУстановитьВидимостьПредмета(ЭтаФорма);
	ПротоколированиеРаботыПользователей.ЗаписатьИзменение(Объект.Ссылка);
	Если ПараметрыЗаписи.Свойство("ЭтоНовыйОбъект") И ПараметрыЗаписи.ЭтоНовыйОбъект = Истина Тогда
		РаботаСФлагамиОбъектовСервер.СохранитьФлагОбъектаИзФормы(ЭтаФорма);
	КонецЕсли;
	
	ЕстьАктивныеПодзадачи = РаботаСБизнесПроцессамиВызовСервера.ЕстьАктивныеПодзадачи(Объект.Ссылка);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЗадачаИзменена", Объект.Ссылка, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)

	Если Настройки["ПоказыватьИнструкции"] <> Неопределено
		И ПолучитьФункциональнуюОпцию("ИспользоватьИнструкции") Тогда
		ПолучитьИнструкции();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ОбзорЗадачКлиент.ПредставлениеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнструкцияПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСИнструкциямиКлиент.ОткрытьСсылку(ДанныеСобытия.Href, ДанныеСобытия.Element, Элемент.Документ);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатВыполненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	РаботаСБизнесПроцессамиКлиент.ВыбратьШаблонТекстаРеализация(ЭтаФорма, "РезультатВыполнения",
		ПредопределенноеЗначение("Перечисление.ОбластиПримененияШаблоновТекстов.ЗадачаОтветственноеИсполнение"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Исполнители

&НаКлиенте
Процедура ИсполнителиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	БизнесПроцессыИЗадачиКлиент.СписокЗадачВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ДеревоПриложений

&НаКлиенте
Процедура ДеревоПриложенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = ДеревоПриложений.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ЗначениеЗаполнено(ТекущиеДанные.ИмяПредмета) И НЕ ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ОчиститьСообщения();
		СообщениеОбОшибке = "";
		
		ПараметрыОбработчикаОповещения = Новый Структура();
		ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ДеревоПриложенийВыборПродолжение",
			ЭтотОбъект,
			ПараметрыОбработчикаОповещения);         
			
		Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(ЭтаФорма, СообщениеОбОшибке, 
			ТекущиеДанные.ИмяПредмета, ТекущиеДанные.Ссылка, СтандартнаяОбработка, ОписаниеОповещения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СообщениеОбОшибке,, "ДеревоПриложений");
			Возврат;
		КонецЕсли;
	Иначе
		РаботаСБизнесПроцессамиКлиент.ДеревоПриложенийВыбор(
			ЭтаФорма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийВыборПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбновитьДеревоПриложений();
		УстановитьПредметСервер();	
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Параметры.СообщениеОбОшибке,, "ДеревоПриложений");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПриАктивизацииСтроки(Элемент)
	
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	СписокВыбора = Новый СписокЗначений;
	СписокВыбора.Добавить("Предмет", НСтр("ru = 'Предмет'"));
	СписокВыбора.Добавить("Файл", НСтр("ru = 'Файл'"));
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения("ДеревоПриложенийПередНачаломДобавления_Завершение", ЭтаФорма);
	
	СписокВыбора.ПоказатьВыборЭлемента(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломДобавления_Завершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Предмет = Неопределено;
	
	Если РезультатВыбора.Значение = "Файл" Тогда
		Предмет = ПредопределенноеЗначение("Справочник.Файлы.ПустаяСсылка");
	КонецЕсли;
	
	ДеревоПриложенийДобавлениеНаКлиенте(Предмет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ОткрытьКарточкуНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ДеревоПриложенийУдалениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЭтаФорма.ТолькоПросмотр Или Элементы.ДеревоПриложений.ТолькоПросмотр Или Объект.Выполнена Тогда 
		Возврат;
	КонецЕсли;
	
	ВладелецФайлаСписка = Объект.БизнесПроцесс;
	НеОткрыватьКарточкуПослеСозданияИзФайла = Истина;
	РаботаСФайламиКлиент.ОбработкаПеретаскиванияВЛинейныйСписок(ПараметрыПеретаскивания, ВладелецФайлаСписка, ЭтаФорма, НеОткрыватьКарточкуПослеСозданияИзФайла);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить()
	
	ОчиститьСообщения();
	Если Записать() Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
		Закрыть();	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьВыполнить(Команда)
	
	Если Записать() Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
		
		ПоказатьОповещениеПользователя(
			"Изменение:", 
			ПолучитьНавигационнуюСсылку(Объект.Ссылка),
			Строка(Объект.Ссылка),
			БиблиотекаКартинок.Информация32);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура Перенаправить(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.Перенаправить(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопрос(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ЗадатьВопрос(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПринятьЗадачуКИсполнению(ЭтаФорма, ТекущийПользователь);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ОтменитьПринятиеЗадачиКИсполнению(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьБизнесПроцесс(Команда)
	
	ПоказатьЗначение(, Объект.БизнесПроцесс);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьХронометраж(Команда)
	
	КомандыРаботыСБизнесПроцессамиКлиент.ПереключитьХронометраж(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьТрудозатраты(Команда)
	
	ДатаОтчета = ТекущаяДата();
	Если Объект.Выполнена Тогда
		ДатаОтчета = Объект.ДатаИсполнения;
	КонецЕсли;	
	
	УчетВремениКлиент.ДобавитьВОтчетКлиент(
		ДатаОтчета,
		ВключенХронометраж, 
		ДатаНачалаХронометража, 
		ДатаКонцаХронометража, 
		ВидыРабот, 
		Объект.Ссылка,
		СпособУказанияВремени,
		ЭтаФорма.Элементы.ПереключитьХронометраж,
		Объект.Выполнена,
		ЭтаФорма);
		
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьДатуВыполнения(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ИзменитьДатуВыполнения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подписаться(Команда)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПараметрыФормы = Новый Структура("ОбъектПодписки", Объект.Ссылка);
		ОткрытьФорму("ОбщаяФорма.ПодпискаНаУведомленияПоОбъекту", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Команда)
	
	ВыполнениеЗадачПоПочтеКлиент.СформироватьУведомлениеДляИсполненияЗадачиПоПочте(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьИнструкции(Команда)
	
	ПоказыватьИнструкции = Не ПоказыватьИнструкции;
	ПолучитьИнструкции();
	
КонецПроцедуры

&НаКлиенте
Процедура Исполнено(Команда)
	
	Если Модифицированность И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	Если РаботаСБизнесПроцессамиКлиент.ЗапретВыполненияИзФормы(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Если Подзадачи.Количество() <> 0 Тогда
		
		ЕстьАктивныеПодзадачи = РаботаСБизнесПроцессамиВызовСервера.ЕстьАктивныеПодзадачи(Объект.Ссылка);
		Если ЕстьАктивныеПодзадачи Тогда
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ИсполненоПослеВыбораДействияСПодзадачами",
				ЭтотОбъект);
			БизнесПроцессыИЗадачиКлиент.ЗадатьВопросОПодзадачахПриВыполненииЗадачи(
				Объект.Ссылка, ОписаниеОповещения);
			Возврат;
			
		КонецЕсли;	
		
	КонецЕсли;	
	
	ИсполненоПослеПодзадач(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполненоПослеВыбораДействияСПодзадачами(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = "ИгнорироватьПодзадачи" Тогда 
		
		ИсполненоПослеПодзадач();
		
	ИначеЕсли Результат = "ПрерватьПодзадачи" Тогда 
		
		БизнесПроцессыИЗадачиВызовСервера.ПрерватьПодзадачи(Объект.Ссылка);
		ИсполненоПослеПодзадач();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсполненоПослеПодзадач() 

	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеВыбораФактическогоИсполнителя", ЭтаФорма);
	
	РаботаСБизнесПроцессамиКлиент.ВыбратьИсполнителяЗадачи(
		ЭтаФорма,
		Объект.Исполнитель,
		ТекущийПользователь,
		ФактическийИсполнительЗадачи,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеВыбораФактическогоИсполнителя(
	ВыбранныйФактическийИсполнитель, ДопПараметры) Экспорт
	
	Если ВыбранныйФактическийИсполнитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйФактическийИсполнитель <> Объект.Исполнитель Тогда
		ФактическийИсполнительЗадачи = ВыбранныйФактическийИсполнитель;
	КонецЕсли;
	
	Если ЕстьНевыполненныеЗадачиИсполнителей() Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Задача не может быть завершена, пока не выполнены все задачи исполнителей'"),,,
			"Исполнители");
		Возврат;
	КонецЕсли;
	
	Если МультипредметностьКлиент.ПроверитьЗаполнениеПредметовЗадачи(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеПроверкиНаЗанятыеФайлы",
		ЭтотОбъект);
		
	РаботаСБизнесПроцессамиКлиент.ПроверитьНаличиеЗанятыхФайлов(ЭтаФорма, ОписаниеОповещения, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеПроверкиНаЗанятыеФайлы(Результат, Параметры) Экспорт
	
	Если Результат <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, 
		"ИсполнениеВыполнениеКомандыИсполнено");
	
	Если Не ВыполнениеЗадачКлиент.ВыполнитьЗадачуИзФормы(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПродолжениеВыполненияЗадачиПослеВводаВремени",
		ЭтотОбъект);
	
	УчетВремениКлиент.ДобавитьВОтчетПослеВыполненияЗадачи(ОпцияИспользоватьУчетВремени,
		Объект.ДатаИсполнения, Объект.Ссылка, ВключенХронометраж, 
		ДатаНачалаХронометража, ДатаКонцаХронометража,
		ВидыРабот, СпособУказанияВремени, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжениеВыполненияЗадачиПослеВводаВремени(Результат, Параметры) Экспорт
	
	ПоказатьОповещениеПользователя(
		НСтр("ru = 'Выполнение:'"),
		ПолучитьНавигационнуюСсылку(Объект.Ссылка),
		Строка(Объект.Ссылка),
		БиблиотекаКартинок.Информация32);
	
	Оповестить("ЗадачаВыполнена", Объект.Ссылка);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПраваДоступа(Команда)
	
	ДокументооборотПраваДоступаКлиент.ОткрытьФормуПравДоступа(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокИсполнителей(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОбновитьПараметрыУсловногоОформленияПросроченныхЗадач(
		Исполнители.УсловноеОформление);
		
	Элементы.Исполнители.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_РаботаСФлагами

&НаКлиенте
Процедура КрасныйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Красный"),
		БиблиотекаКартинок.КрасныйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура СинийФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Синий"),
		БиблиотекаКартинок.СинийФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЖелтыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Желтый"),
		БиблиотекаКартинок.ЖелтыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗеленыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Зеленый"),
		БиблиотекаКартинок.ЗеленыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ОранжевыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Оранжевый"),
		БиблиотекаКартинок.ОранжевыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛиловыйФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.Лиловый"),
		БиблиотекаКартинок.ЛиловыйФлаг);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьФлаг(Команда)
	
	РаботаСФлагамиОбъектовКлиент.УстановитьФлагВФормеОбъекта(
		ЭтаФорма,
		ПредопределенноеЗначение("Перечисление.ФлагиОбъектов.ПустаяСсылка"),
		БиблиотекаКартинок.ПустойФлаг);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_ДеревоПриложений

&НаКлиенте
Процедура ДобавитьПредмет(Команда)
	
	ДеревоПриложенийДобавлениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл(Команда)
	
	ДеревоПриложенийДобавлениеНаКлиенте(ПредопределенноеЗначение("Справочник.Файлы.ПустаяСсылка"));
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПредмет(Команда)
	
	ДеревоПриложенийУдалениеНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДляПросмотра(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ОткрытьТекущийФайлДляПросмотра(ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры	

&НаКлиенте
Процедура Редактировать(Команда)
	
	РаботаСБизнесПроцессамиКлиент.РедактироватьТекущийФайл(
		ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	РаботаСБизнесПроцессамиКлиент.ЗакончитьРедактированиеТекущегоФайла(
		ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	РаботаСБизнесПроцессамиКлиент.СохранитьТекущийФайл(ЭтаФорма, Элементы.ДеревоПриложений);
	
КонецПроцедуры	

&НаКлиенте
Процедура КомандаОбновитьДеревоПриложений(Команда)
	
	ОбновитьДеревоПриложений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьУдаленныеПриложения(Команда)
	
	ОтображатьУдаленныеПриложения = Не ОтображатьУдаленныеПриложения;
	Элементы.ДеревоПриложенийКонтекстноеМенюОтображатьУдаленные.Пометка = ОтображатьУдаленныеПриложения;
	
	ТекущаяСсылкаВДереве = Неопределено;
	Если Элементы.ДеревоПриложений.ТекущиеДанные <> Неопределено Тогда
		ТекущаяСсылкаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.Ссылка;
	КонецЕсли;
	
	ОтображатьУдаленныеПриложенияСервер();
	
	Если ТекущаяСсылкаВДереве <> Неопределено Тогда
		РаботаСБизнесПроцессамиКлиент.УстановитьТекущуюСтрокуВДеревеПриложений(
			ЭтаФорма, 
			ДеревоПриложений.ПолучитьЭлементы(), 
			ТекущаяСсылкаВДереве);
	КонецЕсли;
		
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(
		ЭтаФорма, 
		Элементы.ДеревоПриложений);
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЕстьНевыполненныеЗадачиИсполнителей()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗадачаИсполнителя.Ссылка
	|ИЗ
	|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	|ГДЕ
	|	ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс
	|	И ЗадачаИсполнителя.ТочкаМаршрута = &ТочкаМаршрута
	|	И (НЕ ЗадачаИсполнителя.Выполнена)";
	
	Запрос.УстановитьПараметр("БизнесПроцесс", Объект.БизнесПроцесс);
	Запрос.УстановитьПараметр("ТочкаМаршрута", БизнесПроцессы.Исполнение.ТочкиМаршрута.Исполнить);
	
	Результат = Запрос.Выполнить();
	Возврат Не Результат.Пустой();
	
КонецФункции

&НаСервере
Процедура ПолучитьИнструкции()
	
	РаботаСИнструкциями.ПолучитьИнструкции(ЭтаФорма, 70, 100);
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства 
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ОбновитьПодзадачи()
	
	РаботаСБизнесПроцессамиВызовСервера.ЗаполнитьПодзадачи(ЭтаФорма, Объект);
	
КонецПроцедуры	

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_МобильныйКлиент

&НаСервере
Процедура НастроитьЭлементыФормыДляМобильногоУстройства()
	
	Элементы.ГруппаРеквизитыЗадачи.Видимость = Ложь;
	// Предметы показываем всегда, чтобы была возможность добавить новый.
	Элементы.ДеревоПриложений.Видимость = Истина;
	
	ПараметрыАдаптациии = МобильныйКлиентАдаптацияИнтерфейсаСервер.НовыеПараметрыАдаптацииФормыКарточкиЗадачи();
	ПараметрыАдаптациии.ЭлементРасположениеСтраниц = Элементы.ГруппаРеквизитыЗадачи;
	
	ПараметрыАдаптациии.СтраницыНазвания.Добавить(НСтр("ru='Обзор'"));
	ЭлементыОсновное = Новый Массив;
	ЭлементыОсновное.Добавить(Элементы.ПредставлениеHTML);
	ЭлементыОсновное.Добавить(Элементы.Исполнители);
	ПараметрыАдаптациии.СтраницыЭлементы.Добавить(ЭлементыОсновное);
	
	ПараметрыАдаптациии.СтраницыНазвания.Добавить(НСтр("ru='Предметы'"));
	ПараметрыАдаптациии.СтраницыЭлементы.Добавить(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Элементы.ДеревоПриложений));
	
	ПараметрыАдаптациии.СтраницыНазвания.Добавить(НСтр("ru='Подзадачи'"));
	ПараметрыАдаптациии.СтраницыЭлементы.Добавить(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Элементы.Подзадачи));
		
	Если Объект.Предметы.Количество() > 0 Тогда
		ПараметрыАдаптациии.СтраницыНомерТекущейСтраницы = 1; // Предметы
	Иначе
		ПараметрыАдаптациии.СтраницыНомерТекущейСтраницы = 0; // Реквизиты
	КонецЕсли;
	
	ПараметрыАдаптациии.ЭлементПредметы = Элементы.ДеревоПриложений;
	ПараметрыАдаптациии.ЭлементПредставлениеHTML = Элементы.ПредставлениеHTML;
	ПараметрыАдаптациии.ЭлементЗаписатьИЗакрыть = Элементы.ЗаписатьИЗакрыть;
	ПараметрыАдаптациии.ЭлементГруппаИнструкции = Элементы.ГруппаИнструкции;
	ПараметрыАдаптациии.ЭлементГруппаОбластьВыполнения = Элементы.ГруппаОбластьВыполнения;
	ПараметрыАдаптациии.ЭлементГруппаКомандыВыполнения = Элементы.ГруппаКомандыВыполнения;
	
	МобильныйКлиентАдаптацияИнтерфейсаСервер.АдаптироватьЭлементыФормыКарточкиЗадачи(ЭтотОбъект, ПараметрыАдаптациии);
	
	// Установим картинки у кнопок выполнения задачи.
	Элементы.Исполнено.Картинка = БиблиотекаКартинок.ЗадачаУспешноеВыполнение;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуМК(Команда)
	
	МобильныйКлиентАдаптацияИнтерфейсаКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриСменеСтраницыМК(ТекущаяСтраница)
	
	МобильныйКлиентАдаптацияИнтерфейсаКлиентСервер.ОбновитьСтраницыИПереключатели(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_ДеревоПриложений

&НаСервере
Процедура ОтображатьУдаленныеПриложенияСервер()
	
	РаботаСБизнесПроцессамиВызовСервера.ЗаполнитьДеревоПриложений(ЭтаФорма);
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		ИмяФормы,
		"ОтображатьУдаленныеПриложения",
		ОтображатьУдаленныеПриложения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДеревоПриложений(ТекущееИмяПредметаВДереве = Неопределено)
	
	ТекущаяСсылкаВДереве = Неопределено;
	
	Если Элементы.ДеревоПриложений.ТекущиеДанные <> Неопределено И ТекущееИмяПредметаВДереве = Неопределено Тогда
		ТекущаяСсылкаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.Ссылка;
		ТекущееИмяПредметаВДереве = Элементы.ДеревоПриложений.ТекущиеДанные.ИмяПредмета;
	КонецЕсли;
	
	Если Элементы.Найти("ДеревоПриложений") <> Неопределено  Тогда
		ОбновитьДеревоПриложенийСервер();
	КонецЕсли;
	
	Если ТекущаяСсылкаВДереве <> Неопределено ИЛИ ТекущееИмяПредметаВДереве <> Неопределено Тогда
		РаботаСБизнесПроцессамиКлиент.УстановитьТекущуюСтрокуВДеревеПриложений(
			ЭтаФорма, 
			ДеревоПриложений.ПолучитьЭлементы(), 
			ТекущаяСсылкаВДереве, ТекущееИмяПредметаВДереве);
	КонецЕсли;
		
	РаботаСБизнесПроцессамиКлиент.УстановитьДоступностьКомандРаботыСФайлами(
		ЭтаФорма, 
		Элементы.ДеревоПриложений);
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьДеревоПриложенийСервер()
	
	РаботаСБизнесПроцессамиВызовСервера.ЗаполнитьДеревоПриложений(ЭтаФорма);
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьПредметСервер()
	
	Мультипредметность.УстановитьЗначенияДопРеквизитовИДоступностьЭлементовФормыПроцесса(ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийДобавлениеНаКлиенте(Предмет = Неопределено)

	ОчиститьСообщения();
	СообщениеОбОшибке = "";
	НовыйИмяПредмета = Неопределено;
	
	ПараметрыОбработчикаОповещения = Новый Структура();
	ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДеревоПриложенийВыборПродолжение",
		ЭтотОбъект,
		ПараметрыОбработчикаОповещения);
	
	Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(ЭтаФорма, СообщениеОбОшибке, НовыйИмяПредмета, Предмет,,ОписаниеОповещения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СообщениеОбОшибке,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуНаКлиенте()
	
	ТекущиеДанные = Элементы.ДеревоПриложений.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Ссылка) Тогда
		ПоказатьЗначение(,ТекущиеДанные.Ссылка);
	Иначе
		ОчиститьСообщения();
		СообщениеОбОшибке = "";
		
		ПараметрыОбработчикаОповещения = Новый Структура;
		ПараметрыОбработчикаОповещения.Вставить("СообщениеОбОшибке", СообщениеОбОшибке);
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ОткрытьКарточкуНаКлиентеПродолжение",
			ЭтотОбъект,
			ПараметрыОбработчикаОповещения);
			
		Если Не МультипредметностьКлиент.ДобавитьПредметЗадачи(
			ЭтаФорма,
			СообщениеОбОшибке, 
			ТекущиеДанные.ИмяПредмета,
			ТекущиеДанные.Ссылка,,
			ОписаниеОповещения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СообщениеОбОшибке,, "ДеревоПриложений");
			Возврат;
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуНаКлиентеПродолжение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ОбновитьДеревоПриложений();
		УстановитьПредметСервер();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			Параметры.СообщениеОбОшибке,, "ДеревоПриложений");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийУдалениеНаКлиенте()
	
	ВыделенныеСтрокиПредметов = Новый Массив;
	Для Каждого ВыделеннаяСтр Из Элементы.ДеревоПриложений.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.ДеревоПриложений.ДанныеСтроки(ВыделеннаяСтр);
		ВыделенныеСтрокиПредметов.Добавить(ДанныеСтроки);
	КонецЦикла;
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ДеревоПриложенийУдалениеНаКлиентеПродолжение",
		ЭтотОбъект,
		ВыделенныеСтрокиПредметов);
		
	МультипредметностьКлиент.ПолученоПодтверждениеОбУдаленииПредмета(Объект, ВыделенныеСтрокиПредметов, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийУдалениеНаКлиентеПродолжение(Результат, ВыделенныеСтрокиПредметов) Экспорт
	
	Если Результат = Ложь Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	СообщениеОбОшибке = "";
	
	ИменаУдаляемыхПредметов = Новый Массив;
	Для Каждого ВыделеннаяСтр Из ВыделенныеСтрокиПредметов Цикл
		Если ВыделеннаяСтр.ДоступноУдаление Тогда
			ИменаУдаляемыхПредметов.Добавить(ВыделеннаяСтр.ИмяПредмета);
		КонецЕсли;
	КонецЦикла;
	
	Если ИменаУдаляемыхПредметов.Количество() = 0 Тогда
		
		КоличествоВыделенныхСтрок = ВыделенныеСтрокиПредметов.Количество();
		Если КоличествоВыделенныхСтрок = 1 Тогда
			ТекстСообщения = НСтр("ru = 'Удалить текущий предмет можно только в карточке процесса.'");
		Иначе
			ТекстСообщения = НСтр("ru = 'Удалить выделенные предметы можно только в карточке процесса.'");
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
	
	Если Не МультипредметностьКлиент.УдалитьПредметыЗадачи(ЭтаФорма, СообщениеОбОшибке, ИменаУдаляемыхПредметов) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СообщениеОбОшибке,,
			"ДеревоПриложений");
		Возврат;
	КонецЕсли;
	
	ОбновитьДеревоПриложений();
	УстановитьПредметСервер();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции_Хронометраж

&НаСервере
Процедура ПереключитьХронометражСервер(ПараметрыОповещения) Экспорт
	
	УчетВремени.ПереключитьХронометражСервер(
	ПараметрыОповещения,
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	Объект.Ссылка,
	ВидыРабот,
	ЭтаФорма.Команды.ПереключитьХронометраж,
	ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОтчетИОбновитьФорму(ПараметрыОтчета, ПараметрыОповещения) Экспорт
	
	УчетВремени.ДобавитьВОтчетИОбновитьФорму(
		ПараметрыОтчета, 
		ПараметрыОповещения,
		ДатаНачалаХронометража,
		ДатаКонцаХронометража,
		ВключенХронометраж,
		ЭтаФорма.Команды.ПереключитьХронометраж,
		ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаСервере
Процедура ОтключитьХронометражСервер() Экспорт
	
	УчетВремени.ОтключитьХронометражСервер(
	ДатаНачалаХронометража,
	ДатаКонцаХронометража,
	ВключенХронометраж,
	Объект.Ссылка,
	ЭтаФорма.Команды.ПереключитьХронометраж,
	ЭтаФорма.Элементы.ПереключитьХронометраж);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ОбщегоНазначенияДокументооборотКлиент.ПередЗакрытием(
		Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка, Модифицированность) Тогда
		Возврат;
	КонецЕсли;
	
	РаботаСБизнесПроцессамиКлиент.ЗакончитьРедактированиеФайловПоЗадаче(ЭтаФорма, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПриложенийНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	
	#Если Не ВебКлиент Тогда
		
		ВыделенныеСтроки = Элементы.ДеревоПриложений.ВыделенныеСтроки;
		
		Если ВыделенныеСтроки.Количество() = 1 Тогда
			
			ВыбраннаяСтрока = ВыделенныеСтроки[0];
			ДанныеСтроки = Элементы.ДеревоПриложений.ДанныеСтроки(ВыбраннаяСтрока);	
			ФайлСсылка = ДанныеСтроки.Ссылка;
			
			Если ЗначениеЗаполнено(ФайлСсылка) 
				И ТипЗнч(ФайлСсылка) = Тип("СправочникСсылка.Файлы") Тогда
				
				ДанныеФайла = РаботаСФайламиВызовСервера.ДанныеФайлаДляОткрытия(ФайлСсылка);
				
				ПолноеИмяПеретаскиваемогоФайла = "";
				
				Обработчик = Новый ОписаниеОповещения("ПослеПолучитьФайлВерсииВРабочийКаталог", ЭтотОбъект);
				РаботаСФайламиКлиент.ПолучитьФайлВерсииВРабочийКаталог(Обработчик, 
					ДанныеФайла, ПолноеИмяПеретаскиваемогоФайла, УникальныйИдентификатор);
					
			КонецЕсли;		
			
			Если ЗначениеЗаполнено(ПолноеИмяПеретаскиваемогоФайла) Тогда		
				Файл = Новый Файл(ПолноеИмяПеретаскиваемогоФайла);
				ПараметрыПеретаскивания.Значение = Файл;
				Возврат;
			Иначе
				Выполнение = Ложь;
				Возврат;
			КонецЕсли;	
			
		КонецЕсли;	
		
	#КонецЕсли
	
КонецПроцедуры

// Продолжение процедуры после получения файла на клиент
&НаКлиенте
Процедура ПослеПолучитьФайлВерсииВРабочийКаталог(Результат, ПараметрыВыполнения) Экспорт
	
	Если Результат.ФайлПолучен Тогда
		
		ПолноеИмяПеретаскиваемогоФайла = Результат.ПолноеИмяФайла;
		
		Файл = Новый Файл(ПолноеИмяПеретаскиваемогоФайла);
		Если Файл.Существует() Тогда
			Файл.УстановитьТолькоЧтение(Ложь);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы_Подзадачи

&НаКлиенте
Процедура ПодзадачиПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПодзадачиПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПодзадачиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСБизнесПроцессамиКлиент.ОткрытьПодзадачу(ЭтаФорма, Элемент, ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти
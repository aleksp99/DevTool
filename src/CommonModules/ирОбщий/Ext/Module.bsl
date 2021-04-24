﻿Функция ЭтотРасширениеКонфигурацииЛкс() Экспорт 
	
	// <!-- PushA
	// фрагмент ДОБАВЛЕН:
	УстановитьПривилегированныйРежим(Истина);
	// PushA -->
	
	Результат = Неопределено;
	Если Не ирОбщий.РежимСовместимостиМеньше8_3_4Лкс() Тогда 
		Попытка
			ЭтиРасширения = Вычислить("РасширенияКонфигурации").Получить(); // Антибаг платформы 8.3.10- исправлен в 8.3.11 https://partners.v8.1c.ru/forum/t/1607016/m/1607016
		Исключение
			Возврат Результат;
		КонецПопытки; 
		ОтборРасширений = Новый Структура("Имя", ирОбщий.ИмяПродуктаЛкс());
		ЭтиРасширения = Вычислить("РасширенияКонфигурации").Получить(ОтборРасширений);
		Если ЭтиРасширения.Количество() > 0 Тогда 
			Результат = ЭтиРасширения[0];
		КонецЕсли; 
	КонецЕсли;
	Возврат Результат;

КонецФункции

Функция АдаптироватьРасширениеЛкс(ИмяПользователя = "", ПарольПользователя = "", ВключатьНомерСтроки = Истина) Экспорт 
	
	#Если ТонкийКлиент Или ВебКлиент Тогда
		Результат = ирСервер.АдаптироватьРасширениеЛкс();
		Возврат Результат;
	#КонецЕсли
	ПометкиКоманд = ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ПометкиКоманд",, ирОбщий.ИмяПродуктаЛкс());
	ПодключитьОтладкуВнешнихОбработокБСП = ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ПодключитьОтладкуВнешнихОбработокБСП",, ирОбщий.ИмяПродуктаЛкс());
	//ПодключитьОтладкуОтчетов = ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.ПодключитьОтладкуОтчетов",, ирОбщий.ИмяПродуктаЛкс());
	ПодключитьОтладкуОтчетов = Ложь; // Теперь это делается через глобальную команду
	//СгенерироватьРольВсеПрава = ХранилищеОбщихНастроек.Загрузить(, "ирАдаптацияРасширения.СгенерироватьРольВсеПрава",, ирОбщий.ИмяПродуктаЛкс());
	СгенерироватьРольВсеПрава = Ложь; // Давать права на верхние объекты метаданных недостаточно. Поэтому отключил пока этот флажок
	НадоДобавитьВсеСсылочныеМетаданнные = СгенерироватьРольВсеПрава;
	Для Каждого КлючИЗначение Из ПометкиКоманд Цикл
		Если КлючИЗначение.Значение Тогда 
			НадоДобавитьВсеСсылочныеМетаданнные = Истина;
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
	ЭтотРасширение = ЭтотРасширениеКонфигурацииЛкс();
	#Если Сервер И Не Сервер Тогда
	    ЭтотРасширение = РасширенияКонфигурации.Создать();
	#КонецЕсли
	ИмяРасширения = ЭтотРасширение.Имя;
	ТекстСпискаОбъектовКонфигурации = "";
	Если НадоДобавитьВсеСсылочныеМетаданнные Тогда
		ТипыСсылок = ирОбщий.ОписаниеТиповВсеСсылкиЛкс(Ложь).Типы();
			#Если Сервер И Не Сервер Тогда
			    ТипыСсылок = Новый Массив;
			#КонецЕсли
		ТипыСсылокПлановОбмена = ПланыОбмена.ТипВсеСсылки().Типы();
		
		// Сначала выгружаем из конфигурации все метаданные
		//ТекстСпискаОбъектовКонфигурации = Метаданные.ПолноеИмя();
		ДобавляемыеТипы = СкопироватьУниверсальнуюКоллекциюЛкс(ТипыСсылок);
			#Если Сервер И Не Сервер Тогда
			    ДобавляемыеТипы = Новый Массив;
			#КонецЕсли
		Если СгенерироватьРольВсеПрава Тогда
			ДобавляемыеТипыРегистров = Новый Массив;
			ДобавляемыеТипыРегистров.Добавить("РегистрыСведений");
			ДобавляемыеТипыРегистров.Добавить("РегистрыНакопления");
			ДобавляемыеТипыРегистров.Добавить("РегистрыРасчета");
			ДобавляемыеТипыРегистров.Добавить("РегистрыБухгалтерии");
			ДобавляемыеТипыРегистров.Добавить("Последовательности");
			Для Каждого ИмяКоллекцииРегистров Из ДобавляемыеТипыРегистров Цикл
				Для Каждого ОбъектМД Из Метаданные[ИмяКоллекцииРегистров] Цикл
					ДобавляемыеТипы.Добавить(Тип(СтрЗаменить(ОбъектМД.ПолноеИмя(), ".", "НаборЗаписей.")));
				КонецЦикла; 
			КонецЦикла;
		КонецЕсли; 
		Для Каждого Тип Из ДобавляемыеТипы Цикл
			ОбъектМД = Метаданные.НайтиПоТипу(Тип);
			ТекстСпискаОбъектовКонфигурации = ТекстСпискаОбъектовКонфигурации + Символы.ПС + ОбъектМД.ПолноеИмя();
		КонецЦикла;
		Для Каждого ОбъектМД Из Метаданные.ВнешниеИсточникиДанных Цикл
			Если ОбъектМД.РасширениеКонфигурации() <> Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			ТекстСпискаОбъектовКонфигурации = ТекстСпискаОбъектовКонфигурации + Символы.ПС + ОбъектМД.ПолноеИмя();
		КонецЦикла;
	КонецЕсли; 
	Если ПодключитьОтладкуВнешнихОбработокБСП И ирКэш.НомерВерсииБСПЛкс() >= 204 Тогда
		ТекстСпискаОбъектовКонфигурации = ТекстСпискаОбъектовКонфигурации + Символы.ПС + Метаданные.ОбщиеМодули.ДополнительныеОтчетыИОбработки.ПолноеИмя();
	КонецЕсли; 
	ПодключитьОтладкуОтчетов = ПодключитьОтладкуОтчетов И Метаданные.ОсновнаяФормаОтчета <> Неопределено И Метаданные.ОсновнаяФормаОтчета.РасширениеКонфигурации() = Неопределено;
	Если ПодключитьОтладкуОтчетов Тогда
		ТекстСпискаОбъектовКонфигурации = ТекстСпискаОбъектовКонфигурации + Символы.ПС + Метаданные.ОсновнаяФормаОтчета.ПолноеИмя();
	КонецЕсли; 
	// <!-- PushA
	// фрагмент ДОБАВЛЕН:
	PushA_Роли = Новый Массив;
	Если Метаданные.Роли.Найти("БазовыеПраваБСП") <> Неопределено Тогда 
		ТекстСпискаОбъектовКонфигурации = ТекстСпискаОбъектовКонфигурации + Символы.ПС + Метаданные.Роли.БазовыеПраваБСП.ПолноеИмя();
		PushA_Роли.Добавить("БазовыеПраваБСП");
		Если Метаданные.Роли.Найти("ПолныеПрава") <> Неопределено Тогда 
			ТекстСпискаОбъектовКонфигурации = ТекстСпискаОбъектовКонфигурации + Символы.ПС + Метаданные.Роли.ПолныеПрава.ПолноеИмя();
			PushA_Роли.Добавить("ПолныеПрава");
		КонецЕсли;
		Если Метаданные.Роли.Найти("АдминистраторСистемы") <> Неопределено Тогда 
			ТекстСпискаОбъектовКонфигурации = ТекстСпискаОбъектовКонфигурации + Символы.ПС + Метаданные.Роли.АдминистраторСистемы.ПолноеИмя();
			PushA_Роли.Добавить("АдминистраторСистемы");
		КонецЕсли;
		Если Метаданные.Роли.Найти("Администрирование") <> Неопределено Тогда 
			ТекстСпискаОбъектовКонфигурации = ТекстСпискаОбъектовКонфигурации + Символы.ПС + Метаданные.Роли.Администрирование.ПолноеИмя();
			PushA_Роли.Добавить("Администрирование");
		КонецЕсли;
	КонецЕсли;
	// PushA -->
	ТекстСпискаОбъектовКонфигурации = Сред(ТекстСпискаОбъектовКонфигурации, 2); // !
	ИмяФайлаСпискаВыгрузкиКонфигурации = ПолучитьИмяВременногоФайла("txt");
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(ТекстСпискаОбъектовКонфигурации);
	ТекстовыйДокумент.Записать(ИмяФайлаСпискаВыгрузкиКонфигурации);
	КаталогВыгрузкиКонфигурации = ПолучитьИмяВременногоФайла();
	СоздатьКаталог(КаталогВыгрузкиКонфигурации);
	ТекстЛога = "";
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpConfigToFiles """ + КаталогВыгрузкиКонфигурации + """ -listFile """ + ИмяФайлаСпискаВыгрузкиКонфигурации + """ -Format Plain",
		СтрокаСоединенияИнформационнойБазы(), ТекстЛога, , "Выгрузка конфигурации в файлы",,,, ИмяПользователя, ПарольПользователя);
	УдалитьФайлы(ИмяФайлаСпискаВыгрузкиКонфигурации);
	Если Не Успех Тогда 
		УдалитьФайлы(КаталогВыгрузкиКонфигурации);
		СообщитьЛкс(ТекстЛога);
		Возврат Ложь;
	КонецЕсли;

	// Выгружаем объекты из расширения
	КаталогВыгрузкиРасширения = ПолучитьИмяВременногоФайла();
	ИмяФайлаСпискаВыгрузкиРасширения = ПолучитьИмяВременногоФайла("txt");
	ТекстЛога = "";
	СоздатьКаталог(КаталогВыгрузкиРасширения);
	
	ТекстСпискаОбъектовРасширения = "Конфигурация." + ИмяРасширения;
	Для Каждого КлючИЗначение Из ПометкиКоманд Цикл
		ТекстСпискаОбъектовРасширения = ТекстСпискаОбъектовРасширения + Символы.ПС + "ОбщаяКоманда." + КлючИЗначение.Ключ;
	КонецЦикла;
	ТекстовыйДокумент.УстановитьТекст(ТекстСпискаОбъектовРасширения);
	ТекстовыйДокумент.Записать(ИмяФайлаСпискаВыгрузкиРасширения);
	
	// Пришлось отказаться от частичной загрузки из-за непонятной ошибки
	// Файл - Configuration.xml: ошибка частичной загрузки - идентификатор 15dc941a-fd9f-4d00-bc7e-3ef077518def загружаемой конфигурации отличается от идентификатора b9c0a797-9739-4c3f-a665-796b3bf92d6a сохраненной конфигурации
	//Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpConfigToFiles """ + КаталогВыгрузкиРасширения + """ -Extension """ + ИмяРасширения + """ -listFile """ + ИмяФайлаСпискаВыгрузкиРасширения + """ -Format Plain", 
	//	СтрокаСоединенияИнформационнойБазы(), ТекстЛога, , "Выгрузка расширения в файлы");
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpConfigToFiles """ + КаталогВыгрузкиРасширения + """ -Extension """ + ИмяРасширения + """ -Format Plain", 
		СтрокаСоединенияИнформационнойБазы(), ТекстЛога, , "Выгрузка расширения в файлы",,,, ИмяПользователя, ПарольПользователя);
		
	Если Не Успех Тогда 
		УдалитьФайлы(КаталогВыгрузкиРасширения);
		СообщитьЛкс(ТекстЛога);
		Возврат Ложь;
	КонецЕсли;
	
	// Добавим ссылочные объекты в расширение
	ИмяФайла = КаталогВыгрузкиРасширения + "\Configuration.xml";
	ОписаниеРасширения = Новый ТекстовыйДокумент;
	ОписаниеРасширения.Прочитать(ИмяФайла);
	ОписаниеРасширения = ОписаниеРасширения.ПолучитьТекст();
	
	ДокументДОМ = ирОбщий.ПрочитатьФайлВДокументDOMЛкс(ИмяФайла);
	УзелТиповСпискаОбъектов = ДокументДом.ПолучитьЭлементыПоИмени("ChildObjects");
	УзелТиповСпискаОбъектов = УзелТиповСпискаОбъектов[0];
	Если НадоДобавитьВсеСсылочныеМетаданнные Тогда
		Если СгенерироватьРольВсеПрава Тогда
			ТекстФайлаПрав = Новый ЗаписьXML; 
			ТекстФайлаПрав.УстановитьСтроку("");
			ТекстФайлаПрав.ЗаписатьБезОбработки("<?xml version=""1.0"" encoding=""UTF-8""?>
			|<Rights xmlns=""http://v8.1c.ru/8.2/roles"" xmlns:xs=""http://www.w3.org/2001/XMLSchema"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:type=""Rights"" version=""2.7"">
			|	<setForNewObjects>true</setForNewObjects>
			|	<setForAttributesByDefault>true</setForAttributesByDefault>
			|	<independentRightsOfChildObjects>false</independentRightsOfChildObjects>");
		КонецЕсли; 
		ДобавленныеВнешниеИсточникиДанных = Новый Соответствие;
		Для Каждого Тип Из ДобавляемыеТипы Цикл
			ПолноеИмяМДXML = XMLТип(Тип).ИмяТипа;
			Если Ложь
				Или Найти(ПолноеИмяМДXML, "RoutePointRef.") > 0
			Тогда
				Продолжить;
			КонецЕсли; 
			ЭтоТаблицаВИД = Найти(ПолноеИмяМДXML, "ExternalDataSourceTableRef.") > 0;
			Если ЭтоТаблицаВИД Тогда
				Фрагменты = СтрРазделитьЛкс(ПолноеИмяМДXML);
				Фрагменты[0] = "ExternalDataSource";
				Фрагменты.Вставить(2, "Table");
				МассивТаблицВИД = ДобавленныеВнешниеИсточникиДанных[Фрагменты[1]];
				Если МассивТаблицВИД = Неопределено Тогда
					МассивТаблицВИД = Новый Массив;
					ДобавленныеВнешниеИсточникиДанных.Вставить(Фрагменты[1], МассивТаблицВИД);
				КонецЕсли; 
				ПолноеИмяМДXML = СтрСоединитьЛкс(Фрагменты, ".");
			КонецЕсли; 
			ПолноеИмяМДXML = СтрЗаменить(ПолноеИмяМДXML, "Ref.", ".");
			ПолноеИмяМДXML = СтрЗаменить(ПолноеИмяМДXML, "RecordSet.", ".");
			
			// Добавим в описание конфигурации (Configuration.xml)
			ОбъектМД = Метаданные.НайтиПоТипу(Тип);
			Если Не ЭтоТаблицаВИД Тогда
				ИмяКлассаМДXML = ПервыйФрагментЛкс(ПолноеИмяМДXML);
				ТекстСпискаОбъектовРасширения = ТекстСпискаОбъектовРасширения + Символы.ПС + ОбъектМД.ПолноеИмя();
				Если Найти(ОписаниеРасширения, "<" + ИмяКлассаМДXML + ">" + ОбъектМД.Имя + "<") > 0 Тогда
					Продолжить;
				КонецЕсли; 
				УзелОбъекта = ДокументДом.СоздатьЭлемент(ИмяКлассаМДXML);
				УзелОбъекта.ТекстовоеСодержимое = ОбъектМД.Имя;
				УзелТиповСпискаОбъектов.ДобавитьДочерний(УзелОбъекта);
			Иначе
				МассивТаблицВИД.Добавить(ОбъектМД.Имя);
				ИмяКлассаМДXML = "Table";
			КонецЕсли; 
			
			// Укажем принадлежность объекта в его описании
			ФайлИсточник = Новый Файл(КаталогВыгрузкиКонфигурации + "\" + ПолноеИмяМДXML + ".xml");
			ФайлПриемник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ФайлИсточник.Имя);
			//ПереместитьФайл(ФайлИсточник.ПолноеИмя, ФайлПриемник.ПолноеИмя);
			ТекстовыйДокумент.Прочитать(ФайлИсточник.ПолноеИмя);
			ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
			ЧтоЗаменять = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, "<Properties>", "</" + ИмяКлассаМДXML + ">", Ложь, Истина, Истина);
			НаЧтоЗаменять = 
			"		<Properties>
			|			<Name>" + ирОбщий.ПоследнийФрагментЛкс(ФайлИсточник.ИмяБезРасширения) + "</Name>
			|			<ObjectBelonging>Adopted</ObjectBelonging>
			|		</Properties>
			|		<ChildObjects/>
			|	</" + ИмяКлассаМДXML + ">";
			ТекстФайла = СтрЗаменитьЛкс(ТекстФайла, ЧтоЗаменять, НаЧтоЗаменять);
			ЧтоЗаменять = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, "<" + ИмяКлассаМДXML + " uuid=", ">", Ложь, Истина, Истина);
			НаЧтоЗаменять = "<" + ИмяКлассаМДXML + " uuid=""" + Новый УникальныйИдентификатор + """>";
			ТекстФайла = СтрЗаменитьЛкс(ТекстФайла, ЧтоЗаменять, НаЧтоЗаменять);
			ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
			ТекстовыйДокумент.Записать(ФайлПриемник.ПолноеИмя);
			
			Если СгенерироватьРольВсеПрава Тогда
				Если Истина
					И Найти(ПолноеИмяМДXML, "Enum.") = 0
				Тогда
					// Даем права Просмотр и ПросмотрИстории
					ТекстФайлаПрав.ЗаписатьБезОбработки("
					|	<object>
					|		<name>" + ПолноеИмяМДXML + "</name>
					|		<right>
					|			<name>Read</name>
					|			<value>true</value>
					|		</right>
					|		<right>
					|			<name>View</name>
					|			<value>true</value>
					|		</right>
					|		<right>
					|			<name>ReadDataHistory</name>
					|			<value>true</value>
					|		</right>
					|		<right>
					|			<name>ViewDataHistory</name>
					|			<value>true</value>
					|		</right>
					|	</object>");
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла;
		Для Каждого КлючИЗначение Из ДобавленныеВнешниеИсточникиДанных Цикл
			ПолноеИмяМДXML = "ExternalDataSource." + КлючИЗначение.Ключ;
			ИмяКлассаМДXML = ПервыйФрагментЛкс(ПолноеИмяМДXML);
			
			// Добавим в описание конфигурации (Configuration.xml)
			ОбъектМД = Метаданные.ВнешниеИсточникиДанных[КлючИЗначение.Ключ];
			ТекстСпискаОбъектовРасширения = ТекстСпискаОбъектовРасширения + Символы.ПС + ОбъектМД.ПолноеИмя();
			Если Найти(ОписаниеРасширения, "<" + ИмяКлассаМДXML + ">" + ОбъектМД.Имя + "<") > 0 Тогда
				Продолжить;
			КонецЕсли; 
			УзелОбъекта = ДокументДом.СоздатьЭлемент(ИмяКлассаМДXML);
			УзелОбъекта.ТекстовоеСодержимое = ОбъектМД.Имя;
			УзелТиповСпискаОбъектов.ДобавитьДочерний(УзелОбъекта);
			
			// Укажем принадлежность объекта в его описании
			ФайлИсточник = Новый Файл(КаталогВыгрузкиКонфигурации + "\" + ПолноеИмяМДXML + ".xml");
			ФайлПриемник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ФайлИсточник.Имя);
			//ПереместитьФайл(ФайлИсточник.ПолноеИмя, ФайлПриемник.ПолноеИмя);
			ТекстовыйДокумент.Прочитать(ФайлИсточник.ПолноеИмя);
			ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
			ЧтоЗаменять = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, "<Properties>", "</" + ИмяКлассаМДXML + ">", Ложь, Истина, Истина);
			НаЧтоЗаменять = 
			"		<Properties>
			|			<Name>" + ирОбщий.ПоследнийФрагментЛкс(ФайлИсточник.ИмяБезРасширения) + "</Name>
			|			<ObjectBelonging>Adopted</ObjectBelonging>
			|		</Properties>
			|		<ChildObjects/>
			|	</" + ИмяКлассаМДXML + ">";
			ТекстФайла = СтрЗаменитьЛкс(ТекстФайла, ЧтоЗаменять, НаЧтоЗаменять);
			ЧтоЗаменять = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, "<" + ИмяКлассаМДXML + " uuid=", ">", Ложь, Истина, Истина);
			НаЧтоЗаменять = "<" + ИмяКлассаМДXML + " uuid=""" + Новый УникальныйИдентификатор + """>";
			ТекстФайла = СтрЗаменитьЛкс(ТекстФайла, ЧтоЗаменять, НаЧтоЗаменять);
			ДокументДомВИД = ирОбщий.ПрочитатьТекстВДокументDOMЛкс(ТекстФайла);
			УзелТиповСпискаДочернихОбъектов = ДокументДомВИД.ПолучитьЭлементыПоИмени("ChildObjects");
			УзелТиповСпискаДочернихОбъектов = УзелТиповСпискаДочернихОбъектов[0];
			Для Каждого ИмяТаблицы Из КлючИЗначение.Значение Цикл
				УзелОбъекта = ДокументДомВИД.СоздатьЭлемент("Table");
				УзелОбъекта.ТекстовоеСодержимое = ИмяТаблицы;
				УзелТиповСпискаДочернихОбъектов.ДобавитьДочерний(УзелОбъекта);
			КонецЦикла;
			ирОбщий.ЗаписатьДокументDOMВФайлЛкс(ДокументДомВИД, ФайлПриемник.ПолноеИмя);
		КонецЦикла;
		Если СгенерироватьРольВсеПрава Тогда
			// Добавим в описание конфигурации (Configuration.xml)
			ИмяКлассаМДXML = "Role";
			ТекстСпискаОбъектовРасширения = ТекстСпискаОбъектовРасширения + Символы.ПС + "Роль.ирВсеПрава";
			Если Найти(ОписаниеРасширения, "<" + ИмяКлассаМДXML + ">" + "ирВсеПрава" + "<") = 0 Тогда
				УзелОбъекта = ДокументДом.СоздатьЭлемент(ИмяКлассаМДXML);
				УзелОбъекта.ТекстовоеСодержимое = "ирВсеПрава";
				УзелТиповСпискаОбъектов.ДобавитьДочерний(УзелОбъекта);
			КонецЕсли; 
			
			ФайлПриемник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ИмяКлассаМДXML + ".ирВсеПрава.xml");
			ТекстФайла = "<?xml version=""1.0"" encoding=""UTF-8""?>
			|<MetaDataObject xmlns=""http://v8.1c.ru/8.3/MDClasses"" xmlns:app=""http://v8.1c.ru/8.2/managed-application/core"" xmlns:cfg=""http://v8.1c.ru/8.1/data/enterprise/current-config"" xmlns:cmi=""http://v8.1c.ru/8.2/managed-application/cmi"" xmlns:ent=""http://v8.1c.ru/8.1/data/enterprise"" xmlns:lf=""http://v8.1c.ru/8.2/managed-application/logform"" xmlns:style=""http://v8.1c.ru/8.1/data/ui/style"" xmlns:sys=""http://v8.1c.ru/8.1/data/ui/fonts/system"" xmlns:v8=""http://v8.1c.ru/8.1/data/core"" xmlns:v8ui=""http://v8.1c.ru/8.1/data/ui"" xmlns:web=""http://v8.1c.ru/8.1/data/ui/colors/web"" xmlns:win=""http://v8.1c.ru/8.1/data/ui/colors/windows"" xmlns:xen=""http://v8.1c.ru/8.3/xcf/enums"" xmlns:xpr=""http://v8.1c.ru/8.3/xcf/predef"" xmlns:xr=""http://v8.1c.ru/8.3/xcf/readable"" xmlns:xs=""http://www.w3.org/2001/XMLSchema"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" version=""2.7"">
			|	<Role uuid=""12337ea7-8c90-4575-876c-026b425b5c09"">
			|		<Properties>
			|			<Name>ирВсеПрава</Name>
			|			<Synonym>
			|				<v8:item>
			|					<v8:lang>ru</v8:lang>
			|					<v8:content>Все права (ИР)</v8:content>
			|				</v8:item>
			|			</Synonym>
			|			<Comment>Сгенерирована инструментом ""Адаптация расширения"" для доступа на просмотр ко всем данным</Comment>
			|		</Properties>
			|	</Role>
			|</MetaDataObject>";
			ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
			ТекстовыйДокумент.Записать(ФайлПриемник.ПолноеИмя);
			ФайлПриемник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ИмяКлассаМДXML + ".ирВсеПрава.Rights.xml");
			ТекстФайлаПрав.ЗаписатьБезОбработки("
			|</Rights>");
			ТекстовыйДокумент.УстановитьТекст(ТекстФайлаПрав.Закрыть());
			ТекстовыйДокумент.Записать(ФайлПриемник.ПолноеИмя);
		КонецЕсли; 
	КонецЕсли; 
	
	Если ПодключитьОтладкуВнешнихОбработокБСП И ирКэш.НомерВерсииБСПЛкс() >= 204 Тогда
		ИмяОбъектаОригинала = "ДополнительныеОтчетыИОбработки";
		ИмяОбъектаРасширения = "ирДополнительныеОтчетыИОбработкиБСП";
		// Добавим в описание конфигурации (Configuration.xml)
		ИмяКлассаМДXML = "CommonModule";
		ОбъектМД = Метаданные.ОбщиеМодули[ИмяОбъектаОригинала];
		ТекстСпискаОбъектовРасширения = ТекстСпискаОбъектовРасширения + Символы.ПС + ОбъектМД.ПолноеИмя();
		Если Найти(ОписаниеРасширения, "<" + ИмяКлассаМДXML + ">" + ОбъектМД.Имя + "<") = 0 Тогда
			УзелОбъекта = ДокументДом.СоздатьЭлемент(ИмяКлассаМДXML);
			УзелОбъекта.ТекстовоеСодержимое = ОбъектМД.Имя;
			УзелТиповСпискаОбъектов.ДобавитьДочерний(УзелОбъекта);
			
			// Укажем принадлежность объекта в его описании
			ФайлИсточник = Новый Файл(КаталогВыгрузкиКонфигурации + "\" + ИмяКлассаМДXML + "." + ОбъектМД.Имя + ".xml");
			ФайлПриемник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ФайлИсточник.Имя);
			//ПереместитьФайл(ФайлИсточник.ПолноеИмя, ФайлПриемник.ПолноеИмя);
			ТекстовыйДокумент.Прочитать(ФайлИсточник.ПолноеИмя);
			ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
			ЧтоЗаменять = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, "<Properties>", "</" + ИмяКлассаМДXML + ">", Ложь, Истина, Истина);
			НаЧтоЗаменять = 
			"		<Properties>
			|			<Name>" + ИмяОбъектаОригинала + "</Name>
			|			<ObjectBelonging>Adopted</ObjectBelonging>
			|		</Properties>
			|	</" + ИмяКлассаМДXML + ">";
			ТекстФайла = СтрЗаменитьЛкс(ТекстФайла, ЧтоЗаменять, НаЧтоЗаменять);
			ЧтоЗаменять = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, "<" + ИмяКлассаМДXML + " uuid=", ">", Ложь, Истина, Истина);
			НаЧтоЗаменять = "<" + ИмяКлассаМДXML + " uuid=""" + Новый УникальныйИдентификатор + """>";
			ТекстФайла = СтрЗаменитьЛкс(ТекстФайла, ЧтоЗаменять, НаЧтоЗаменять);
			ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
			ТекстовыйДокумент.Записать(ФайлПриемник.ПолноеИмя);
		КонецЕсли;
		ФайлИсточник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ИмяКлассаМДXML + "." + ИмяОбъектаРасширения + ".Module.txt");
		ФайлПриемник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ИмяКлассаМДXML + "." + ОбъектМД.Имя + ".Module.txt");
		ТекстовыйДокумент.Прочитать(ФайлИсточник.ПолноеИмя);
		ТекстовыйДокумент.Записать(ФайлПриемник.ПолноеИмя);
	КонецЕсли; 
	// <!-- PushA
	// фрагмент ДОБАВЛЕН:
	Для PushA_Индекс = 0 По PushA_Роли.ВГраница() Цикл 
		ИмяОбъектаОригинала = PushA_Роли[PushA_Индекс];
		ИмяОбъектаРасширения = "ирРазработчик";
		// Добавим в описание конфигурации (Configuration.xml)
		ИмяКлассаМДXML = "Role";
		ОбъектМД = Метаданные.Роли[ИмяОбъектаОригинала];
		ТекстСпискаОбъектовРасширения = ТекстСпискаОбъектовРасширения + Символы.ПС + ОбъектМД.ПолноеИмя();
		Если Найти(ОписаниеРасширения, "<" + ИмяКлассаМДXML + ">" + ОбъектМД.Имя + "<") = 0 Тогда
			УзелОбъекта = ДокументДом.СоздатьЭлемент(ИмяКлассаМДXML);
			УзелОбъекта.ТекстовоеСодержимое = ОбъектМД.Имя;
			УзелТиповСпискаОбъектов.ДобавитьДочерний(УзелОбъекта);
			
			// Укажем принадлежность объекта в его описании
			ФайлИсточник = Новый Файл(КаталогВыгрузкиКонфигурации + "\" + ИмяКлассаМДXML + "." + ОбъектМД.Имя + ".xml");
			ФайлПриемник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ФайлИсточник.Имя);
			//ПереместитьФайл(ФайлИсточник.ПолноеИмя, ФайлПриемник.ПолноеИмя);
			ТекстовыйДокумент.Прочитать(ФайлИсточник.ПолноеИмя);
			ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
			ЧтоЗаменять = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, "<Properties>", "</" + ИмяКлассаМДXML + ">", Ложь, Истина, Истина);
			НаЧтоЗаменять = 
			"		<Properties>
			|			<Name>" + ИмяОбъектаОригинала + "</Name>
			|			<ObjectBelonging>Adopted</ObjectBelonging>
			|		</Properties>
			|	</" + ИмяКлассаМДXML + ">";
			ТекстФайла = СтрЗаменитьЛкс(ТекстФайла, ЧтоЗаменять, НаЧтоЗаменять);
			ЧтоЗаменять = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, "<" + ИмяКлассаМДXML + " uuid=", ">", Ложь, Истина, Истина);
			НаЧтоЗаменять = "<" + ИмяКлассаМДXML + " uuid=""" + Новый УникальныйИдентификатор + """>";
			ТекстФайла = СтрЗаменитьЛкс(ТекстФайла, ЧтоЗаменять, НаЧтоЗаменять);
			ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
			ТекстовыйДокумент.Записать(ФайлПриемник.ПолноеИмя);
		КонецЕсли;
		ФайлИсточник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ИмяКлассаМДXML + "." + ИмяОбъектаРасширения + ".Rights.xml");
		ФайлПриемник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ИмяКлассаМДXML + "." + ОбъектМД.Имя + ".Rights.xml");
		ТекстовыйДокумент.Прочитать(ФайлИсточник.ПолноеИмя);
		ТекстовыйДокумент.Записать(ФайлПриемник.ПолноеИмя);
	КонецЦикла;
	// PushA -->
	Если ПодключитьОтладкуОтчетов И Метаданные.ОсновнаяФормаОтчета <> Неопределено Тогда
		ИмяОбъектаОригинала = Метаданные.ОсновнаяФормаОтчета.Имя;
		ИмяОбъектаРасширения = Метаданные.ОбщиеФормы.ирФормаОтчетаРасширение.Имя;
		// Добавим в описание конфигурации (Configuration.xml)
		ИмяКлассаМДXML = "CommonForm";
		ОбъектМД = Метаданные.ОбщиеФормы[ИмяОбъектаОригинала];
		ТекстСпискаОбъектовРасширения = ТекстСпискаОбъектовРасширения + Символы.ПС + ОбъектМД.ПолноеИмя();
		Если Найти(ОписаниеРасширения, "<" + ИмяКлассаМДXML + ">" + ОбъектМД.Имя + "<") = 0 Тогда
			УзелОбъекта = ДокументДом.СоздатьЭлемент(ИмяКлассаМДXML);
			УзелОбъекта.ТекстовоеСодержимое = ОбъектМД.Имя;
			УзелТиповСпискаОбъектов.ДобавитьДочерний(УзелОбъекта);
			
			// Укажем принадлежность объекта в его описании
			ФайлИсточник = Новый Файл(КаталогВыгрузкиКонфигурации + "\" + ИмяКлассаМДXML + "." + ОбъектМД.Имя + ".xml");
			ФайлПриемник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ФайлИсточник.Имя);
			//ПереместитьФайл(ФайлИсточник.ПолноеИмя, ФайлПриемник.ПолноеИмя);
			ТекстовыйДокумент.Прочитать(ФайлИсточник.ПолноеИмя);
			ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
			ЧтоЗаменять = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, "<Properties>", "</" + ИмяКлассаМДXML + ">", Ложь, Истина, Истина);
			НаЧтоЗаменять = 
			"		<Properties>
			|			<Name>" + ИмяОбъектаОригинала + "</Name>
			|			<ObjectBelonging>Adopted</ObjectBelonging>
			|			<FormType>Managed</FormType>
			|		</Properties>
			|	</" + ИмяКлассаМДXML + ">";
			ТекстФайла = СтрЗаменитьЛкс(ТекстФайла, ЧтоЗаменять, НаЧтоЗаменять);
			ЧтоЗаменять = ирОбщий.СтрокаМеждуМаркерамиЛкс(ТекстФайла, "<" + ИмяКлассаМДXML + " uuid=", ">", Ложь, Истина, Истина);
			НаЧтоЗаменять = "<" + ИмяКлассаМДXML + " uuid=""" + Новый УникальныйИдентификатор + """>";
			ТекстФайла = СтрЗаменитьЛкс(ТекстФайла, ЧтоЗаменять, НаЧтоЗаменять);
			ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
			ТекстовыйДокумент.Записать(ФайлПриемник.ПолноеИмя);
		КонецЕсли;
		// Модуль
		ФайлИсточник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ИмяКлассаМДXML + "." + ИмяОбъектаРасширения + ".Form.Module.txt");
		ФайлПриемник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ИмяКлассаМДXML + "." + ОбъектМД.Имя + ".Form.Module.txt");
		ТекстовыйДокумент.Прочитать(ФайлИсточник.ПолноеИмя);
		ТекстовыйДокумент.Записать(ФайлПриемник.ПолноеИмя);
		// Диалог
		ФайлИсточник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ИмяКлассаМДXML + "." + ИмяОбъектаРасширения + ".Form.xml");
		ФайлПриемник = Новый Файл(КаталогВыгрузкиРасширения + "\" + ИмяКлассаМДXML + "." + ОбъектМД.Имя + ".Form.xml");
		ТекстовыйДокумент.Прочитать(ФайлИсточник.ПолноеИмя);
		ТекстФайла = ТекстовыйДокумент.ПолучитьТекст();
		ЧтоЗаменять = "<Event name=""OnCreateAtServer"">";
		НаЧтоЗаменять = "<Event name=""OnCreateAtServer"" callType=""After"">";
		ТекстФайла = СтрЗаменитьЛкс(ТекстФайла, ЧтоЗаменять, НаЧтоЗаменять);
		ЧтоЗаменять = "</Events>";
		НаЧтоЗаменять = "<BaseForm><ChildItems/><Attributes/><Commands/><Parameters/></BaseForm>";
		ТекстФайла = СтрЗаменитьЛкс(ТекстФайла, ЧтоЗаменять, НаЧтоЗаменять, Истина);
		ТекстовыйДокумент.УстановитьТекст(ТекстФайла);
		ТекстовыйДокумент.Записать(ФайлПриемник.ПолноеИмя);
	КонецЕсли; 
	ирОбщий.ЗаписатьДокументDOMВФайлЛкс(ДокументДом, ИмяФайла);
	
	// Добавим типы ссылочных объектов в общие команды
	#Если Сервер И Не Сервер Тогда
	    ТипыСсылок = Новый ОписаниеТипов;
	#КонецЕсли
	Для Каждого КлючИЗначение Из ПометкиКоманд Цикл
		ИмяКоманды = КлючИЗначение.Ключ;
		ИмяФайла = КаталогВыгрузкиРасширения + "\CommonCommand." + ИмяКоманды + ".xml";
		ДокументДОМ = ирОбщий.ПрочитатьФайлВДокументDOMЛкс(ИмяФайла);
		УзелТиповПараметра = ДокументДом.ПолучитьЭлементыПоИмени("CommandParameterType");
		УзелТиповПараметра = УзелТиповПараметра[0];
		Пока УзелТиповПараметра.ДочерниеУзлы.Количество() > 0 Цикл
			УзелТиповПараметра.УдалитьДочерний(УзелТиповПараметра.ПервыйДочерний);
		КонецЦикла;
		Если КлючИЗначение.Значение Тогда
			Если ИмяКоманды = Метаданные.ОбщиеКоманды.ирРедактироватьИзмененияНаУзле.Имя Тогда
				ТипыПараметра = ТипыСсылокПлановОбмена;
			Иначе
				ТипыПараметра = ТипыСсылок;
			КонецЕсли;
			Для Каждого Тип Из ТипыПараметра Цикл
				УзелТипа = ДокументДом.СоздатьЭлемент("v8:Type"); // http://v8.1c.ru/8.1/data/core
				УзелТипа.ТекстовоеСодержимое = "cfg:" + XMLТип(Тип).ИмяТипа; // http://v8.1c.ru/8.1/data/enterprise/current-config
				УзелТиповПараметра.ДобавитьДочерний(УзелТипа);
			КонецЦикла;
		КонецЕсли; 
		ирОбщий.ЗаписатьДокументDOMВФайлЛкс(ДокументДом, ИмяФайла);
	КонецЦикла;
	
	ТекстЛога = "";
	
	// Пришлось отказаться от частичной загрузки из-за непонятной ошибки
	// Файл - Configuration.xml: ошибка частичной загрузки - идентификатор 15dc941a-fd9f-4d00-bc7e-3ef077518def загружаемой конфигурации отличается от идентификатора b9c0a797-9739-4c3f-a665-796b3bf92d6a сохраненной конфигурации
	//ФайлыДляЗагрузки = НайтиФайлы(КаталогВыгрузкиРасширения, "*");
	//ТекстовыйДокумент.Очистить();
	//Для Каждого Файл Из ФайлыДляЗагрузки Цикл
	//	ТекстовыйДокумент.ДобавитьСтроку(Файл.ПолноеИмя);
	//КонецЦикла;
	//ТекстовыйДокумент.Записать(ИмяФайлаСпискаВыгрузкиРасширения);
	//Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/LoadConfigFromFiles """ + КаталогВыгрузкиРасширения + """ -Extension """ + ИмяРасширения + """ -listFile """ + ИмяФайлаСпискаВыгрузкиРасширения + """ -Format Plain",
	//	СтрокаСоединенияИнформационнойБазы(), ТекстЛога,,, "Загрузка расширения из файлов");
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/LoadConfigFromFiles """ + КаталогВыгрузкиРасширения + """ -Extension """ + ИмяРасширения + """ -Format Plain",
		СтрокаСоединенияИнформационнойБазы(), ТекстЛога, , "Загрузка расширения из файлов",,,, ИмяПользователя, ПарольПользователя);
		
	УдалитьФайлы(КаталогВыгрузкиРасширения);
	Если Не Успех Тогда 
		СообщитьЛкс(ТекстЛога);
		Возврат Ложь;
	КонецЕсли;
	
	// Почему то без этого расширение не применялось (оставалась активной кнопка "Обновить конфигурацию БД"
	//ЭтотРасширение.Записать();
	КонечныйФайл = ПолучитьИмяВременногоФайла();
	Успех = ирОбщий.ВыполнитьКомандуКонфигуратораЛкс("/DumpCfg """ + КонечныйФайл + """ -Extension """ + ИмяРасширения + """", СтрокаСоединенияИнформационнойБазы(), ТекстЛога,,,,,, ИмяПользователя, ПарольПользователя);
	Если Не Успех Тогда 
		СообщитьЛкс(ТекстЛога);
		Возврат Ложь;
	КонецЕсли;
	ЭтотРасширение.Записать(Новый ДвоичныеДанные(КонечныйФайл));
	Возврат Истина;
	
КонецФункции

Процедура ОткрытьОтладкаВнешнихОбработокБСПЛкс() Экспорт
	
	// <!-- PushA
	// фрагмент ИЗМЕНЕН:
	//ОткрытьФормуЛкс("ОбщаяФорма.ирОтладкаВнешнихОбработокБСП");
	#Если ТонкийКлиент Или ВебКлиент Или МобильныйКлиент Тогда 
		ОткрытьФорму("ОбщаяФорма.ирОтладкаВнешнихОбработокБСП");
	#Иначе 
		ОткрытьФормуЛкс("ОбщаяФорма.ирОтладкаВнешнихОбработокБСП");
	#КонецЕсли
	// PushA -->
	
КонецПроцедуры
using { flights.db as db } from '../db/schema';

@path:'/browse'
service FlightsService {
  entity Departments as SELECT from db.Departments;
  entity Employees as SELECT from db.Employees;
  entity Flights as projection on db.Flights;
  
  @readonly entity Cities as SELECT from db.Cities;
  @readonly entity Airports as projection on db.Airports;
  @readonly entity Weather as SELECT from db.WeatherReports;
}

annotate FlightsService.Flights with @(
    UI: {
      HeaderInfo: {
        TypeName: '{i18n>Flight.TypeName}',
        TypeNamePlural: '{i18n>Flight.TypeNamePlural}',
        Title: { $Type: 'UI.DataField', Value: id }
      },    
      SelectionFields: [ origin_iata, destination_iata, employee_eid ],      
      LineItem: [
        {$Type: 'UI.DataField', Value: id},
        {$Type: 'UI.DataField', Value: origin_image_url},
        {$Type: 'UI.DataField', Value: origin_iata},
        {$Type: 'UI.DataField', Value: destination_image_url},
        {$Type: 'UI.DataField', Value: destination_iata},
        {$Type: 'UI.DataField', Value: employee_eid},
        {$Type: 'UI.DataField', Value: date},
        {$Type: 'UI.DataField', Value: price}
      ],
      HeaderFacets: [       
        {$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#EmployeeDetail', Label:'{i18n>Flight.HeaderFacetEmployeeDetails}' },
        {$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#OriginDetail', Label:'{i18n>Flight.HeaderFacetOrigin}' },
        {$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#OriginWeatherDetail', Label:'{i18n>Flight.HeaderFacetOriginWeather}' },
        {$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#DestinationDetail', Label:'{i18n>Flight.HeaderFacetDestination}' },
        {$Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#DestinationWeatherDetail', Label:'{i18n>Flight.HeaderFacetDestinationWeather}' },
        {$Type: 'UI.ReferenceFacet', Target: '@UI.DataPoint#Date'},
        {$Type: 'UI.ReferenceFacet', Target: '@UI.DataPoint#Price'}
      ],
      DataPoint#Date:  {Value: date, Title: '{i18n>Flight.HeaderDate}'},   
      DataPoint#Price: {Value: price, Title: '{i18n>Flight.HeaderPrice}'},      
      FieldGroup#EmployeeDetail: {
        Data:[
          {$Type: 'UI.DataField', Value: employee.name},
          {$Type: 'UI.DataField', Value: employee.eid},
          {$Type: 'UI.DataField', Value: employee.department_name}
        ]
      },
      FieldGroup#OriginDetail: {
        Data:[
          {$Type: 'UI.DataField', Value: origin.city_name}
        ]
      },
      FieldGroup#OriginWeatherDetail: {
        Data:[
          {$Type: 'UI.DataField', Value: origin.weather.current_description},
          {$Type: 'UI.DataField', Value: origin.weather.current_temperature}
        ]
      },
      FieldGroup#DestinationDetail: {
        Data:[
          {$Type: 'UI.DataField', Value: destination.city_name}
        ]
      },
      FieldGroup#DestinationWeatherDetail: {
        Data:[
          {$Type: 'UI.DataField', Value: destination.weather.current_description},
          {$Type: 'UI.DataField', Value: destination.weather.current_temperature}
        ]
      }
    }
);

annotate FlightsService.Flights with {
  id @( Common: { Label: '{i18n>Flight.FlightID}'} );
  origin @( Common.Label: '{i18n>Flight.OriginIATA}' );
  destination @( Common.Label: '{i18n>Flight.DestinationIATA}' );
  price @( Common.Label: '{i18n>Flight.FlightPrice}', Measures.ISOCurrency: currency_code );
  date @( Common.Label: '{i18n>Flight.FlightDate}' );
  employee @( Common.Label: '{i18n>Flight.EID}' );
  origin_image_url @( UI.IsImageURL: true);
  destination_image_url @( UI.IsImageURL: true);
}

DECLARE @accountnum nvarchar(30);
SET @accountnum = '*CA14459';

SELECT distinct 
p.FirstName as [First Name A], 
p.LastName as [Last Name A], 
h.ArrivalDate as [Arrival Date A], 
h.DepartureDate as [Departure Date A], 
h.HotelVendorCode as [Hotel VendorCode A],
h.ConfirmationNbr as [Confirmation # A], 
h.RecordLocator as [RecordLocator A],
dup.FirstName as [First Name B], 
dup.LastName as [Last Name B],
dup.ArrivalDate as [Arrival Date B], 
dup.DepartureDate as [Departure Date B],  
dup.HotelVendorCode as [Hotel VendorCode B],
dup.ConfirmationNbr as [Confirmation # B], 
dup.RecordLocator as [RecordLocator B]
FROM TktRemarks as t
left join Passenger as p ON p.TravelOrderIdentifier = t.TravelOrderIdentifier
left join HtlSeg as h ON h.TravelOrderIdentifier = t.TravelOrderIdentifier
inner join (SELECT distinct p.FirstName, p.LastName, h.ArrivalDate, h.DepartureDate, h.HotelVendorCode, h.HotelAddress, h.GalileoPropertyNbr, h.GalileoPropertyNbr2, h.ConfirmationNbr, h.RecordLocator
FROM TktRemarks as t
left join Passenger as p ON p.TravelOrderIdentifier = t.TravelOrderIdentifier
left join HtlSeg as h ON h.TravelOrderIdentifier = t.TravelOrderIdentifier
WHERE t.RemarkText = @accountnum
and h.ArrivalDate >= getdate() and h.ArrivalDate <= dateAdd(month, 2, getdate())) as dup on SUBSTRING(dup.FirstName,1,(CHARINDEX(' ',dup.FirstName + ' ')-1)) = SUBSTRING(p.FirstName,1,(CHARINDEX(' ',p.FirstName + ' ')-1)) and dup.LastName = p.lastname and dup.RecordLocator <> h.RecordLocator
WHERE t.RemarkText = @accountnum
and ((h.ArrivalDate < dup.DepartureDate)  and  (h.DepartureDate > dup.ArrivalDate))
and h.RecordLocator > dup.RecordLocator
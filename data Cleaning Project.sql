-- Cleaning the data in SQl

Select * from Nashouse

-- Standardize date format 

Select SaledateConvert , CONVERT(Date, SaleDate)

from Nashouse

Update Nasdata..Nashouse
Set SaleDate = convert(Date, SaleDate)

Alter table Nasdata..Nashouse
Add SaledateConvert Date;

Update Nasdata..Nashouse
Set SaledateConvert = convert(Date, SaleDate)

-- Populate Property Address data 



Select *

from Nashouse
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID
, a.PropertyAddress
,b.ParcelID,
b.PropertyAddress,
Isnull(a.PropertyAddress, b.PropertyAddress)

from Nashouse a
Join Nashouse b on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a

Set PropertyAddress= Isnull(a.PropertyAddress, b.PropertyAddress)

from Nashouse a
Join Nashouse b on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into indiviual column  (Address, city, state)

Select PropertyAddress

from Nashouse
--where PropertyAddress is null
--order by ParcelID

Select 
Substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
Substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) as Address


from Nashouse

Alter table Nasdata..Nashouse
Add PropertysplitAddress NVarchar(255);

Update Nasdata..Nashouse
Set  PropertysplitAddress = Substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table Nasdata..Nashouse
Add Propertysplitcity Nvarchar(255);

Update Nasdata..Nashouse
Set Propertysplitcity = Substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))

Select * from
Nashouse

Select 
Parsename(replace (OwnerAddress,',','.'),3) as address,
Parsename(replace (OwnerAddress,',','.'),2) as city,
Parsename(replace (OwnerAddress,',','.'),1) as State 
from Nashouse

Alter table Nasdata..Nashouse
Add Ownersplitaddress Nvarchar(255);

Update Nasdata..Nashouse
Set Ownersplitaddress = Parsename(replace (OwnerAddress,',','.'),3)

Alter table Nasdata..Nashouse
Add Ownersplitcity Nvarchar(255);

Update Nasdata..Nashouse
Set Ownersplitcity = Parsename(replace (OwnerAddress,',','.'),2)

Alter table Nasdata..Nashouse
Add Ownersplitstate Nvarchar(255);

Update Nasdata..Nashouse
Set Ownersplitstate = Parsename(replace (OwnerAddress,',','.'),1)

Select * from Nashouse

-- Change Y and N  to yes and No in Sold as Vacant 

Select distinct(SoldAsVacant)
From Nashouse

Select SoldAsVacant
, case when SoldAsVacant = 'N' then 'No'
when SoldAsVacant = 'Y' then 'Yes'
else SoldAsVacant
End
From Nashouse

Update Nashouse
Set SoldAsVacant = case when SoldAsVacant = 'N' then 'No'
when SoldAsVacant = 'Y' then 'Yes'
else SoldAsVacant
End

 -- Remove dupliates
 
 With CTE as 
 (Select * ,
 ROW_NUMBER() over (
 partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			Order by UniqueID) as row_num

 from 
 Nashouse
 --order by ParcelID
 )
  Select * from CTE
 where row_num >1


 Delete from CTE
 where row_num >1



 Select * ,
 ROW_NUMBER() over (
 partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			Order by UniqueID)

 from 
 Nashouse
order by ParcelID

-- Delete Unused Column

Select * From Nashouse
Alter table Nashouse
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter table Nashouse
Drop Column SaleDate
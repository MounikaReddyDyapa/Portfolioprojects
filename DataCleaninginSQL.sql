/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashvilleHousing]

  --cleaning data in SQL queries

  select *
  from PortfolioProject.dbo.NashvilleHousing

  --standardize the date format
  
  select SaleDateConverted, CONVERT(Date, SaleDate)
  from PortfolioProject.dbo.NashvilleHousing

  update NashvilleHousing
  set SaleDate = CONVERT(Date, SaleDate)

  ALTER TABLE NashvilleHousing
  ADD SaleDateConverted DATE;

  UPDATE NashvilleHousing
  set SaleDateConverted = CONVERT(Date, SaleDate)

  --Populate Property Address Data

  select *
  from PortfolioProject.dbo.NashvilleHousing
  --where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
	where a.PropertyAddress is null
	order by a.ParcelID asc

Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
	where a.PropertyAddress is null

--breaking out address into individual columns

select PropertyAddress
  from PortfolioProject.dbo.NashvilleHousing
  --where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
  ADD PropertySplitAddress Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
  set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
  ADD PropertySplitCity Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
  set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



select *
From PortfolioProject.dbo.NashvilleHousing


select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
from PortfolioProject.dbo.NashvilleHousing
 
 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
  ADD Ownersplitaddress Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
  set Ownersplitaddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
   
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
  ADD Ownersplitcity Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
  set Ownersplitcity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

  ALTER TABLE PortfolioProject.dbo.NashvilleHousing
  ADD Ownersplitstate Nvarchar(255);

UPDATE PortfolioProject.dbo.NashvilleHousing
  set Ownersplitstate = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--change Y and N to Yes and No in "SoldAsVacant" field

select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2



Select SoldAsVacant 
, case when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
from PortfolioProject.dbo.NashvilleHousing


Update PortfolioProject.dbo.NashvilleHousing
Set SoldAsVacant = case when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


--Remove Duplicates

WITH RowNumCTE AS(
select *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY 
			     UniqueID
				 ) row_num

from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE 
WHERE row_num > 1
--Order by PropertyAddress


--Delete Unused columns

select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate


















	
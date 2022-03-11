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
      ,[SaleDateConverted]
  FROM [Portfolio Project ].[dbo].[NashvilleHousing]


   Select SaleDateConverted, CONVERT(date, SaleDate)
FROM [Portfolio Project ].[dbo].[NashvilleHousing]

Update NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate)

ALTER TABLE NashVilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)

--Populate Property Address Data

  Select *
FROM [Portfolio Project ].[dbo].[NashvilleHousing]
--Where PropertyAddress is null 
order by ParcelID

  Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project ].[dbo].[NashvilleHousing] a
JOIN [Portfolio Project ].[dbo].[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

	Update a
	SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	FROM [Portfolio Project ].[dbo].[NashvilleHousing] a
JOIN [Portfolio Project ].[dbo].[NashvilleHousing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null


	--Breaking out Address into Individual Columns (Address, City, State)

	Select PropertyAddress
FROM [Portfolio Project ].[dbo].[NashvilleHousing]
--Where PropertyAddress is null 
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

FROM [Portfolio Project ].[dbo].[NashvilleHousing]

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
FROM [Portfolio Project ].[dbo].[NashvilleHousing]


Select OwnerAddress
FROM [Portfolio Project ].[dbo].[NashvilleHousing]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM [Portfolio Project ].[dbo].[NashvilleHousing]



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
FROM [Portfolio Project ].[dbo].[NashvilleHousing]


Select OwnerAddress
FROM [Portfolio Project ].[dbo].[NashvilleHousing]

Select
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1)
FROM [Portfolio Project ].[dbo].[NashvilleHousing]

Select *
FROM [Portfolio Project ].[dbo].[NashvilleHousing]


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM [Portfolio Project ].[dbo].[NashvilleHousing]
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM [Portfolio Project ].[dbo].[NashvilleHousing]


Update NashVilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

	  --remove duplicates 
	  


	  WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM [Portfolio Project ].[dbo].[NashvilleHousing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
FROM [Portfolio Project ].[dbo].[NashvilleHousing]

--Delete Unused Columns


Select *
FROM [Portfolio Project ].[dbo].[NashvilleHousing]

ALTER TABLE [Portfolio Project ].[dbo].[NashvilleHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
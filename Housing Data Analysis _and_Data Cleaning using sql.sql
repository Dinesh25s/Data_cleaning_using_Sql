--- Data Analysis & Data Cleaning on National_Housing_dataset
select*
from National_Housing_DataSet

--Populating Property Adress Data

select PropertyAddress
from National_Housing_DataSet
where PropertyAddress is null

select nhd1.ParcelID,nhd1.PropertyAddress,nhd2.ParcelID,nhd2.PropertyAddress
from National_Housing_DataSet nhd1
join National_Housing_DataSet nhd2
	on nhd1.ParcelID = nhd2.ParcelID
	and nhd1.UniqueID <> nhd2.UniqueID
where nhd1.PropertyAddress is null

update nhd1
set PropertyAddress = ISNULL(nhd1.PropertyAddress,nhd2.PropertyAddress)
from National_Housing_DataSet nhd1
join National_Housing_DataSet nhd2
	on nhd1.ParcelID = nhd2.ParcelID
	and nhd1.UniqueID <> nhd2.UniqueID
where nhd1.PropertyAddress is null

---Breaking out Address into Individual Colums (Adress, City,State)

select PropertyAddress
from National_Housing_DataSet

select
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
substring(PropertyAddress,21,CHARINDEX(',',PropertyAddress)) as City
from National_Housing_Dataset

Alter Table National_Housing_Dataset
add PropertySplitAddress Nvarchar(255);

update National_Housing_DataSet
set PropertyAddress = substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter Table National_Housing_Dataset
add PropertySplitCity Nvarchar(255);

update National_Housing_DataSet
set PropertySplitCity = substring(PropertyAddress,21,CHARINDEX(',',PropertyAddress)) 


--- Ownear Address Spliting  and Cleaning Data Organiging  in the Correct Format --

select OwnerAddress
from National_Housing_DataSet

Select 
PARSENAME(Replace(OwnerAddress, ',','.') , 3) as OwnerAddress,
PARSENAME(Replace(OwnerAddress, ',','.') , 2) as OwnerCity,
PARSENAME(Replace(OwnerAddress, ',','.') , 1) as OwnerState
from National_Housing_DataSet

Alter Table National_Housing_Dataset
add OwnerSplitAddress Nvarchar(255);

update National_Housing_DataSet
set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',','.') , 3) 

Alter Table National_Housing_Dataset
add OwnerSplitCity Nvarchar(255);

update National_Housing_DataSet
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',','.') , 2) 

Alter Table National_Housing_Dataset
add OwnerSplitState Nvarchar(255);

update National_Housing_DataSet
set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',','.') , 1) 

select *
from National_Housing_DataSet

--counting the total 1 and 0 " Sold as Vacant' field
select Distinct(SoldAsVacant), Count(SoldAsVacant)
from National_Housing_DataSet
Group by SoldAsVacant
Order by 2

--Removing Duplicates

with RowNumCTE as(
SELECT *,
	ROW_NUMBER() over(
	Partition By ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by
					UniqueID
					) row_num

FROM National_Housing_DataSet
)
select *
from RowNumCTE
where row_num > 1


-- Deleting Unused Columes in The Dataset

select *
from National_Housing_DataSet

alter Table National_Housing_DataSet
drop column PropertySplitAddress,PropertySplitCity

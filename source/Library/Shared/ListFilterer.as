class Shared.ListFilterer
{
   var iItemFilter;
   var EntryMatchesFunc;
   var dispatchEvent;
   var _filterArray;
   function ListFilterer()
   {
      this.iItemFilter = 4294967295;
      this.EntryMatchesFunc = this.EntryMatchesFilter;
      gfx.events.EventDispatcher.initialize(this);
   }
   function get itemFilter()
   {
      return this.iItemFilter;
   }
   function set itemFilter(aiNewFilter)
   {
      var _loc2_ = this.iItemFilter != aiNewFilter;
      this.iItemFilter = aiNewFilter;
      if(_loc2_ == true)
      {
         this.dispatchEvent({type:"filterChange"});
      }
   }
   function get filterArray()
   {
      return this._filterArray;
   }
   function set filterArray(aNewArray)
   {
      this._filterArray = aNewArray;
   }
   function SetPartitionedFilterMode(abPartition)
   {
      this.EntryMatchesFunc = !abPartition ? this.EntryMatchesFilter : this.EntryMatchesPartitionedFilter;
   }
   function EntryMatchesFilter(aEntry)
   {
      return aEntry != undefined && (aEntry.filterFlag == undefined || (aEntry.filterFlag & this.iItemFilter) != 0);
   }
   function EntryMatchesPartitionedFilter(aEntry)
   {
      var _loc3_ = false;
      if(aEntry != undefined)
      {
         if(this.iItemFilter == 4294967295)
         {
            _loc3_ = true;
         }
         else
         {
            var _loc2_ = aEntry.filterFlag;
            var _loc4_ = _loc2_ & 0xFF;
            var _loc7_ = (_loc2_ & 0xFF00) >>> 8;
            var _loc6_ = (_loc2_ & 0xFF0000) >>> 16;
            var _loc5_ = (_loc2_ & 4278190080) >>> 24;
            _loc3_ = _loc4_ == this.iItemFilter || _loc7_ == this.iItemFilter || _loc6_ == this.iItemFilter || _loc5_ == this.iItemFilter;
         }
      }
      return _loc3_;
   }
   function GetPrevFilterMatch(aiStartIndex)
   {
      var _loc3_ = undefined;
      if(aiStartIndex != undefined)
      {
         var _loc2_ = aiStartIndex - 1;
         while(_loc2_ >= 0 && _loc3_ == undefined)
         {
            if(this.EntryMatchesFunc(this._filterArray[_loc2_]))
            {
               _loc3_ = _loc2_;
            }
            _loc2_ = _loc2_ - 1;
         }
      }
      return _loc3_;
   }
   function GetNextFilterMatch(aiStartIndex)
   {
      var _loc3_ = undefined;
      if(aiStartIndex != undefined)
      {
         var _loc2_ = aiStartIndex + 1;
         while(_loc2_ < this._filterArray.length && _loc3_ == undefined)
         {
            if(this.EntryMatchesFunc(this._filterArray[_loc2_]))
            {
               _loc3_ = _loc2_;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
      return _loc3_;
   }
   function ClampIndex(aiStartIndex)
   {
      var _loc2_ = aiStartIndex;
      if(aiStartIndex != undefined && !this.EntryMatchesFunc(this._filterArray[_loc2_]))
      {
         var _loc4_ = this.GetNextFilterMatch(_loc2_);
         var _loc3_ = this.GetPrevFilterMatch(_loc2_);
         if(_loc4_ != undefined)
         {
            _loc2_ = _loc4_;
         }
         else if(_loc3_ != undefined)
         {
            _loc2_ = _loc3_;
         }
         else
         {
            _loc2_ = -1;
         }
         if(_loc4_ != undefined && _loc3_ != undefined && _loc3_ != _loc4_ && _loc2_ == _loc4_ && this._filterArray[_loc3_].text == this._filterArray[aiStartIndex].text)
         {
            _loc2_ = _loc3_;
         }
      }
      return _loc2_;
   }
}

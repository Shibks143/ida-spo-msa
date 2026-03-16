function  [isNonConvLIST, isSingularLIST, isCollapsedLIST] = Prak_assignValues(isNonConv, isSingular, isCollapsed, listIndex)
        isNonConvLIST(1, listIndex) = isNonConv;
        isSingularLIST(1, listIndex) = isSingular;
        isCollapsedLIST(1, listIndex) = isCollapsed;
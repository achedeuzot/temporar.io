import MainView    from './main';
import PasteNewView from './paste/new';
import PasteShowView from './paste/show';

// Collection of specific view modules
const views = {
    PasteNewView,
    PasteShowView,
};

export default function loadView(viewName) {
    return views[viewName] || MainView;
}

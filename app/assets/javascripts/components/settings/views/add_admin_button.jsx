import React from 'react';
import Popover from '../../common/popover.jsx';
import PopoverExpandable from '../../high_order/popover_expandable.jsx';
import AddAdminForm from '../containers/add_admin_form_container';

class AddAdminButton extends React.Component {
  constructor() {
    super();
    this.getKey = this.getKey.bind(this);
  }

  getKey() {
    return `add_${this.props.source}_button`;
  }

  render() {
    const form = <AddAdminForm handlePopoverClose={this.props.open} />;
    return (
      <div className="pop__container">
        <button className="button dark" onClick={this.props.open}>Add Admin</button>
        <Popover
          is_open={this.props.is_open}
          edit_row={form}
          right
        />
      </div>
    );
  }
}

export default PopoverExpandable(AddAdminButton);


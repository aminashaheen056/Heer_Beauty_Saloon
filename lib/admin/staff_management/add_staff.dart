import 'package:flutter/material.dart';

import '../admin_store.dart';
import '../admin_theme.dart';

/// Adds a new staff member, or edits [staff] when one is passed in.
class AddStaffScreen extends StatefulWidget {
  final StaffMember? staff;

  const AddStaffScreen({super.key, this.staff});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _specialization;
  late final TextEditingController _experience;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _description;
  late String _image;

  bool get _editing => widget.staff != null;

  @override
  void initState() {
    super.initState();
    final s = widget.staff;
    _name = TextEditingController(text: s?.name ?? '');
    _specialization = TextEditingController(text: s?.specialization ?? '');
    _experience = TextEditingController(text: s?.experience ?? '');
    _phone = TextEditingController(text: s?.phone ?? '');
    _email = TextEditingController(text: s?.email ?? '');
    _description = TextEditingController(text: s?.description ?? '');
    _image = s?.image ?? AdminAssets.images.first;
  }

  @override
  void dispose() {
    _name.dispose();
    _specialization.dispose();
    _experience.dispose();
    _phone.dispose();
    _email.dispose();
    _description.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final s = widget.staff;
    if (s == null) {
      AdminStore.staff.add(StaffMember(
        id: AdminStore.nextId('st'),
        name: _name.text.trim(),
        specialization: _specialization.text.trim(),
        experience: _experience.text.trim(),
        rating: 0,
        phone: _phone.text.trim(),
        email: _email.text.trim(),
        image: _image,
        description: _description.text.trim(),
      ));
    } else {
      s.name = _name.text.trim();
      s.specialization = _specialization.text.trim();
      s.experience = _experience.text.trim();
      s.phone = _phone.text.trim();
      s.email = _email.text.trim();
      s.image = _image;
      s.description = _description.text.trim();
      // Keep the name on existing appointments in sync.
      for (final a in AdminStore.appointmentsOfStaff(s.id)) {
        a.staffName = s.name;
      }
    }

    AdminUi.snack(context, _editing ? 'Staff member updated' : 'Staff member added');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.cream,
      appBar: AdminUi.appBar(_editing ? 'Edit Staff' : 'Add Staff'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ClipOval(
                  child: Image.asset(
                    _image,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: 110,
                      height: 110,
                      color: AdminColors.softBeige,
                      child: const Icon(Icons.person,
                          size: 48, color: AdminColors.mocha),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AdminImagePicker(
                value: _image,
                onChanged: (v) => setState(() => _image = v),
              ),
              AdminUi.field(_name, 'Full name',
                  icon: Icons.person_outline,
                  validator: AdminUi.validateRequired),
              AdminUi.field(_specialization, 'Specialization',
                  icon: Icons.workspace_premium_outlined,
                  hint: 'e.g. Hair Styling & Hair Colour',
                  validator: AdminUi.validateRequired),
              AdminUi.field(_experience, 'Experience',
                  icon: Icons.timeline,
                  hint: 'e.g. 5 years',
                  validator: AdminUi.validateRequired),
              AdminUi.field(_phone, 'Phone number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: AdminUi.validateRequired),
              AdminUi.field(_email, 'Email address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: AdminUi.validateEmail),
              AdminUi.field(_description, 'About',
                  icon: Icons.notes,
                  maxLines: 4,
                  validator: AdminUi.validateRequired),
              const SizedBox(height: 6),
              AdminUi.primaryButton(
                _editing ? 'SAVE CHANGES' : 'ADD STAFF MEMBER',
                _save,
                icon: _editing ? Icons.save : Icons.person_add_alt_1,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

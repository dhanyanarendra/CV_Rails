# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
issues = Issue.create([{ name: 'Healthcare'}, {name: 'Firearms'}, {name: 'Judicial Appointments'}, {name: 'Campaign Finance'}, {name: 'Surveillance/Privacy/NSA'}, {name: 'Drug Policy'}, {name: 'Entitlements'}, {name: 'Affirmative Action'}, {name: 'Abortion'}, {name: 'Immigration'}, {name: 'Civil Rights'}, {name: 'Religious Freedom'}, {name: 'Death Penalty'}, {name: 'Welfare'}, {name: 'Jobs/Min. Wage'}, {name: 'Taxes'}, {name: 'Education'}, {name: 'Trade'}, {name: 'Environment'}, {name: 'National Security'}, {name: 'National Debt'}, {name: 'Size of Government'}, {name: 'Social Issues'}, {name: 'Crime'}, {name: 'Veterans Affairs'}])
interest = Interest.create([{name: 'Call'}, {name: 'Canvass'}, {name: 'Data Entry'}, {name: 'Drive'}, {name: 'Fundraiser'}, {name: 'Letter'}, {name: 'Meet'}, {name: 'Protest'}, {name: 'Rally'}, {name: 'Research'}, {name: 'Signage'}, {name: 'Social Media'}])

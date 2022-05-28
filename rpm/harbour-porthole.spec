# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.32
# 

Name:       harbour-porthole

# >> macros
# << macros

Summary:    Porthole
Version:    0.3.1
Release:    1
Group:      Qt/Qt
License:    MIT
URL:        https://github.com/black-sheep-dev/harbour-porthole
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-porthole.yaml
Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   nemo-qml-plugin-notifications-qt5
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(nemonotifications-qt5)
BuildRequires:  qt5-qttools-linguist
BuildRequires:  desktop-file-utils

%description
Porthole is a Sailfish OS application to control a Pi-hole server

  %if "%{?vendor}" == "chum"
  PackageName: Porthole
  Type: desktop-application
  Categories:
      - Utility
  Custom:
      DescriptionMD: https://github.com/black-sheep-dev/harbour-porthole/raw/master/README.md
      Repo: https://github.com/black-sheep-dev/harbour-porthole/
  Icon: https://raw.githubusercontent.com/black-sheep-dev/harbour-porthole/master/icons/172x172/harbour-porthole.png
  Screenshots:
      - https://github.com/black-sheep-dev/harbour-porthole/raw/master/metadata/screenshot01.png
      - https://github.com/black-sheep-dev/harbour-porthole/raw/master/metadata/screenshot02.png
      - https://github.com/black-sheep-dev/harbour-porthole/raw/master/metadata/screenshot03.png
  Url:
      Donation: https://www.paypal.com/paypalme/nubecula/1
  %endif


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qmake5 

make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
# >> files
# << files

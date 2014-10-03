# La liste des paquets
# Chaque nom de paquet correspond à un répertoire contenant la structure d'un paquet Debian
PKGS = dptinf dev-c dev-web util-info
PKGS_DEB = $(PKGS:%=$(DEST_DIR)/%.deb)

# Le répertoire où seront placés les .deb créés
DEST_DIR = pkgs.deb

# Le dépôt où seront déposés les paquets
REPO = /mnt/nasgul/guestrepo/trusty

# La version d'Ubuntu
VERSION = trusty

# Par défaut, tous les paquets sont construits
all : $(PKGS_DEB) $(DEST_DIR)

# Création du répertoire de destination
$(DEST_DIR) :
	mkdir $@

# La règle générique pour la construction des paquets
$(DEST_DIR)/%.deb : DEBVERSION=$(lastword $(shell grep "^Version" $<))
$(DEST_DIR)/%.deb : ARCH=$(lastword $(shell grep "^Architecture" $<))
$(DEST_DIR)/%.deb : %/DEBIAN/control
	touch $@
	dpkg -b $(notdir $(basename $@)) $(basename $@)_$(DEBVERSION)_$(ARCH).deb
$(DEST_DIR)/%.deb : %/DEBIAN/postinst

# Création du graphe de dépendance du paquet
# Le paquet doit se trouver sans un dépôt accessible par apt
%.dot :
	debtree --max-depth=2 $(basename $@) > $@

%.pdf : %.dot
	dot -Tpdf -o $@ $<

.PHONY: install listrepo cleanrepo debgraph clean
install: PKG2INSTALL=$(wildcard $(DEST_DIR)/*_*_*.deb) 
install:
	reprepro -Vb $(REPO) includedeb $(VERSION) $(PKG2INSTALL)

listrepo:
	reprepro -Vb $(REPO) list $(VERSION)

cleanrepo:
	reprepro -Vb $(REPO) remove $(VERSION) $(PKGS)

clean:
	rm -r $(PKGS_DEB)


# La liste des paquets
# Chaque nom de paquet correspond à un répertoire contenant la structure d'un paquet Debian
PKGS = dev-c dev-web
PKGS_DEB = $(PKGS:%=$(DEST_DIR)/%.deb)

# Le répertoire où seront placés les .deb créés
DEST_DIR = pkgs.deb

# Par défaut, tous les paquets sont construits
all : $(PKGS_DEB) $(DEST_DIR)

# Création du répertoire de destination
$(DEST_DIR) :
	mkdir $@

# La règle générique pour la construction des paquets
$(DEST_DIR)/%.deb : VERSION=$(lastword $(shell grep "^Version" $<))
$(DEST_DIR)/%.deb : ARCH=$(lastword $(shell grep "^Architecture" $<))
$(DEST_DIR)/%.deb : %/DEBIAN/control
	touch $@
	dpkg -b $(notdir $(basename $@)) $(basename $@)_$(VERSION)_$(ARCH).deb
$(DEST_DIR)/%.deb : %/DEBIAN/postinst

.PHONY: clean
clean:
	rm -r $(PKGS_DEB)
